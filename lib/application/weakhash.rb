require 'weakref'

# Please note, this class does not override every last method of Hash,
# using any other method e.g. values will return weakrefs. If need be
# there's no harm in declaring more methods here--we've just never
# needed them.
class WeakHash < Hash
  def []= key, val
    super(key, WeakRef.new(val))
  end

  def [] key
    ref = super(key)
    return if ref.nil?
    self.delete(key) unless ref.weakref_alive?
    # dereference the object so it doesn't get garbage collected now that it's being used.
    ref.__getobj__ if ref.weakref_alive?
  end

  def has_key? key
    self[key]
    super(key)
  end
end
