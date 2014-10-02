module AssociationsInstanceMethods
  require 'jruby/synchronized'

  def find_target attr, params = {}
    # here's a breakdown of what's going on.
    # we store references to each instantiated object at the class level
    # we store associated objects at the class level
    # to look up an associated object, we obtain the object from the class's associations
    # (to get it's class and ID)
    # we then look up the latest instance of that object and return that.
    if persisted?
      # look up the cached version of the attribute
      associations_cache = self.class.associations_cache(self.id)
      obj = associations_cache[attr]
      # dereference each result to ensure we have the latest version
      obj = obj.class.instances[obj.id] if obj.kind_of? PersistedModel
      obj = obj.map { |o| o.class.instances[o.id] } if obj.kind_of? Array
      # unfortunately if search params are passed in, we can't use cached results
      # without needlessly re-implementing a lot of logic in the backing store
      if obj.nil? or params.length > 0
        # do a new search and cache the objects we received
        old_obj = obj
        obj = self.class.associations[attr].find_target(self, params)
        unless obj.nil?
          Array(obj).each { |o|
            o.class.instances[o.id] = o
          }
        end
        # if we previously had an object but no longer do, we need to delete the old one
        if obj.nil? and !old_obj.nil?
          Array(old_obj).each { |o|
            o.class.instances.remove(o.id)
          }
        end
      else
        Array(obj).each { |o|
          o.class.instances[o.id] = o unless o.nil?
        }
      end
      # we can't cache this result if search parameters were used
      associations_cache[attr] = obj unless params.length > 0
      obj # the line above might not have been executed
    else
      @unsaved_associations ||= {}
      if @unsaved_associations.has_key?(attr)
        # note, params must be ignored in this case. trying to use solr filters
        # on unsaved objects is a degenerate corner case anyways.
        @unsaved_associations[attr]
      else
        self.class.associations[attr].default
      end
    end
  end

  def assign_target attr, val
    @unsaved_associations ||= {}
    if persisted?
      associations_cache = self.class.associations_cache(self.id)
      old_val = associations_cache[attr]
      Array(old_val).map { |x|
        x.class.instances[x.id] = nil if x.kind_of? PersistedModel
      }
      associations_cache[attr] = val
      @unsaved_associations.delete(attr)
      self.class.associations[attr].assign_target(self, val)
      Array(val).map { |x|
        x.class.instances[x.id] = x if x.kind_of? PersistedModel
      }
    else
      @unsaved_associations[attr] = val
    end
  end

  private
  def save_associated_objects
    @unsaved_associations ||= {}
    # re-assigning objects when the parent is persisted will associate and save them
    @unsaved_associations.each { |attr, val|
      assoc = self.class.associations[attr]
      if assoc.auto_save?
        self.send("#{attr}=", val)
      end
    }
  end

  def delete_associated_objects
    self.class.associations.values.each { |assoc|
      if assoc.destroy_deps?
        assoc.destroy_target(self)
      end
    }
  end
end

module AssociationsClassMethods
  class Association
    def initialize(owner_class, target, options = {})
      @association_type = nil
      @owner_class = owner_class
      @target_class = Object.const_get(target.to_s.camelize)
      @foreign_key = options[:foreign_key].to_sym if options[:foreign_key]
      @auto_save = options[:auto_save].nil? ? true : options[:auto_save]
      # we don't differentiate these because destroy is pretty direct
      @destroy_deps = [:destroy, :delete].include?(options[:dependent])
      @target = nil
    end

    def find_target(owner, params = {})
    end

    def assign_target owner, val
    end

    def default
    end

    def auto_save?
      @auto_save
    end

    def destroy_deps?
      @destroy_deps
    end

    def destroy_target attr
    end
  end

  class BelongsToAssociation < Association
    def initialize(owner_class, target, options = {})
      super(owner_class, target, options)
      @association_type = :belongs_to
      @foreign_key = "#{@target_class.name.underscore}_id".to_sym unless @foreign_key
    end

    def find_target(owner, params = {})
      owner_id = owner.send(@foreign_key)
      @target_class.find(owner_id) unless owner_id.nil?
    end

    def assign_target owner, target
      # ActiveRecord does not auto-save when assigning via a belongs-to relationship,
      # but assigning then saving does what you'd expect

      # dependent => delete/destroy also don't affect the old association (if any)
      owner.send("#{@foreign_key}=", target.nil? ? nil : target.id)
      nil
    end
  end

  class HasManyAssociation < Association
    @@default = []
    def initialize(owner_class, target, options = {})
      super(owner_class, target, options)
      @association_type = :has_many
      @foreign_key = "#{@owner_class.name.underscore}_id".to_sym unless @foreign_key
    end

    def find_target(owner, params = {})
      params[:filters] = {@foreign_key => owner.id}
      Array(@target_class.query(params))
    end

    def assign_target owner, target
      Array(find_target(owner)).each { |val|
        # don't mess with records that are still associated
        unless target.include? val
          if @destroy_deps
            val.destroy
          else
            val.send("#{@foreign_key}=", nil) unless target.include? val
            val.save
          end
        end
      }
      target.each { |val|
        val.send("#{@foreign_key}=", owner.id)
        val.save if owner.persisted?
      }
    end

    def destroy_target owner
      if @destroy_deps
        Array(find_target(owner)).each { |val|
          val.destroy
        }
      end
    end

    def default
      []
    end
  end

  class HasOneAssociation < HasManyAssociation
    @@default = nil
    def initialize(owner_class, target, options = {})
      super(owner_class, target, options)
      @association_type = :has_one
    end

    def find_target owner, params = {}
      # FIXME: Should we be ignoring params entirely? Are there any that even make sense
      # when there's at most one result?
      params[:rows] = 1
      params[:per_page] = 1
      super(owner, params).first
    end

    def assign_target owner, target
      # Array(nil) is [] not [nil]. this is important
      super(owner, Array(target))
    end

    def default
    end
  end

  def wrap_public_accessors
    # if any data elements of this instance get modified, we want the
    # association at the class level to become stale
    self.public_attr_names.each { |attr|
      unless method_defined?("_#{attr}=")
        alias_method "_#{attr}=", "#{attr}="
        define_method "#{attr}=" do |*args|
          self.class.instances.delete self.id
          self.send("_#{attr}=", *args)
        end
      end
    }
  end

  def synthesize_association_methods attr
    unless method_defined?(attr)
      define_method attr do |params = {}|
        find_target attr, params
      end
    end

    unless method_defined?("#{attr}=")
      define_method "#{attr}=" do |val|
        assign_target attr, val
      end
    end

    wrap_public_accessors
  end

  def synthesize_indirect_association_methods attr, through
    unless method_defined?(attr)
      define_method attr do
        Array(find_target(through)).map { |x| x.send(attr) }.flatten
      end
    end

    unless method_defined?("#{attr}=")
      define_method "#{attr}=" do |val|
        raise PersistedModelExceptions::IndirectAssociationAssignment.new, \
            "Can't assign '#{attr}' because it is indirectly associated through '#{through}'"
      end
    end

    wrap_public_accessors
  end

  def has_one attr, options = {}
    unless options[:through]
      # initialize associations by calling getter
      self.associations
      @associations[attr] = HasOneAssociation.new(self, attr, options)
      synthesize_association_methods attr
    else
      synthesize_indirect_association_methods attr, options[:through]
    end
  end

  def has_many attr, options = {}
    unless options[:through]
      self.associations
      @associations[attr] = HasManyAssociation.new(self, attr, options)
      synthesize_association_methods attr
    else
      synthesize_indirect_association_methods attr, options[:through]
    end
  end

  def belongs_to attr, options = {}
    self.associations
    @associations[attr] = BelongsToAssociation.new(self, attr, options)
    synthesize_association_methods attr
  end

  def associations
    if @associations.nil?
      @associations = {}
      @associations.extend JRuby::Synchronized
    end
    @associations
  end

  def associations_cache id
    if @associations_cache.nil?
      @associations_cache = WeakHash.new
      @associations_cache.extend JRuby::Synchronized
    end
    unless @associations_cache.has_key? id
      cache = @associations_cache[id] = WeakHash.new
      cache.extend JRuby::Synchronized
    end
    @associations_cache[id]
  end

  def instances
    if @instances.nil?
      @instances = WeakHash.new
      @instances.extend JRuby::Synchronized
    end
    @instances
  end
end
