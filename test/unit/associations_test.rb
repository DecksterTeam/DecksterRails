require 'test_helper'

# begin test object model
# this is a little tortured but it allows us to define our model in-line
class Foo < PersistedModel
end

class Bar < PersistedModel
  public_attr_accessor :title_t, :foo_id

  belongs_to :foo
end

class Baz < PersistedModel
  public_attr_accessor :title_t, :foo_id

  belongs_to :foo
end

class Foo < PersistedModel
  public_attr_accessor :title_t

  has_one :bar
  has_many :baz
end

# end test object model

# begin through object model
class ObjX < PersistedModel
end

class ObjY < PersistedModel
end

class ObjZ < PersistedModel
  public_attr_accessor :title_t, :obj_y_id

  belongs_to :obj_y
end

class ObjY < PersistedModel
  public_attr_accessor :title_t, :obj_x_id, :obj_z_id
  belongs_to :obj_x
  has_many :obj_z
end

class ObjX < PersistedModel
  public_attr_accessor :title_t
  has_many :obj_y
  has_many :obj_z, :through => :obj_y
end

# end through object model

# begin autosave model
class SaveX < PersistedModel
end

class SaveY < PersistedModel
  belongs_to :save_x
end

class SaveX < PersistedModel
  has_one :save_y, :auto_save => false
end
# end autosave model

# begin override model
class OParent < PersistedModel
end

class OChild < PersistedModel
end

class OSubChild < PersistedModel
  public_attr_accessor :title_t

  belongs_to :o_child
end

class OChild <PersistedModel
  public_attr_accessor :title_t

  belongs_to :o_parent
  has_one :o_sub_child
end

class OParent < PersistedModel
  public_attr_accessor :title_t

  def o_sub_child
    "custom reader"
  end

  def o_sub_child=(val)
    @test_value = val
  end

  def o_child
    "custom reader"
  end

  def o_child=(val)
    @test_value = val
  end

  has_one :o_child
end

# end override model

# begin dependent model
class DParent < PersistedModel
end

class DChild < PersistedModel
  public_attr_accessor :d_parent_id

  # this dep doesn't make sense due to where the foreign keys are
  # we're simply testing that it gets ignored
  belongs_to :d_parent, :dependent => :destroy
end

class DParent < PersistedModel
  public_attr_accessor :d_child_id

  has_one :d_child, :dependent => :destroy
end

# end dependent model

class DeviceTest < ActiveSupport::TestCase
  test "has_one read" do
    test_string = "this is a test"
    f = Foo.new(:title_t => "parent")
    bar = Bar.new(:title_t => test_string)
    f.save

    # bypass assocaition logic because we're interested in read not write.
    bar.foo_id = f.id
    bar.save

    assert f.bar.class.name == "Bar", "has_one object lookup failed"
    assert f.bar.title_t == test_string, "has_one wrong record was retrieved"
  end

  test "has_one multiple children" do
    # deliberately assign two objects to one has-one relationship just to see that things don't break
    # this should never happen, but it's worth making sure we do something sane
    f = Foo.new(:title_t => "parent")
    b1 = Bar.new(:title_t => "first")
    b2 = Bar.new(:title_t => "second")
    f.save

    # bypass assocaition logic because we're interested in read not write.
    b1.foo_id = f.id
    b1.save
    b2.foo_id = f.id
    b2.save

    # this behavior is undefined so we shouldn't enforce rules about which object we find
    # (it'll likely be "first" though)
    assert !f.bar.class.nil?, "should have found one object"
    assert ["first", "second"].include?(f.bar.title_t), "wrong child retrieved"
    assert b1.foo == f
    assert b2.foo == f
  end

  test "has_one assign before save" do
    test_string = "made up string"
    f = Foo.new(:title_t => "parent")
    bar = Bar.new(:title_t => test_string)

    f.bar = bar
    assert !f.instance_variable_get("@unsaved_associations")[:bar].nil?, \
        "bar isn't being tracked as unsaved"
    f.save
    assert f.instance_variable_get("@unsaved_associations")[:bar].nil?, \
        "bar is still being tracked as unsaved after save"

    assert bar.foo_id == f.id, "bar was not associated with parent"
    assert bar.persisted?, "bar was not saved when parent was"
  end

  test "has_one assign after save" do
    test_string = "made up string"
    f = Foo.new(:title_t => "parent")
    bar = Bar.new(:title_t => test_string)

    f.save
    f.bar = bar

    assert bar.foo_id == f.id, "bar was not associated with parent"
    assert bar.persisted?, "bar was not saved when parent was"
  end

  test "has_one re-assign child" do
    test_string = "made up string"
    f = Foo.new(:title_t => "parent")
    b1 = Bar.new(:title_t => test_string)
    b2 = Bar.new(:title_t => test_string)

    f.bar = b1
    f.save
    assert b1.foo_id = f.id, "has_one target not associated with parent"

    f.bar = b2

    b1 = Bar.find(b1.id)
    assert b1.foo_id == nil, "has_one target not dis-associated with parent"
  end

  test "has_one object cache" do
    test_string = "different test"
    changed_string = "modified test"
    f = Foo.new(:title_t => "parent")
    bar = Bar.new(:title_t => test_string)
    f.save
    bar.foo_id = f.id
    bar.save

    # cache the record
    f.bar

    bar.title_t = changed_string
    bar.save

    # ensure the original record doesn't reflect changes yet
    assert f.bar.class.name == "Bar", "has_one object lookup failed"
    assert f.bar.title_t == changed_string, "has_one record should have been updated"

    # get a new copy of the parent object and try again
    f = Foo.find(f.id)
    assert f.bar.class.name == "Bar", "has_one object lookup failed"
    assert f.bar.title_t == changed_string, "has_one record is wrong"
  end

  test "has_one with no record" do
    f = Foo.new(:title_t => "parent")
    assert f.bar.nil?, "(unsaved record) empty has_one should be nil"

    f.save
    assert f.bar.nil?, "(saved record) empty has_one should still be nil"
  end

  test "has_one assign to nil" do
    test_string = "foo"
    f = Foo.new(:title_t => "parent")
    bar = Bar.new(:title_t => test_string)
    f.bar = bar
    f.save

    f.bar = nil

    assert Bar.find(bar.id).foo_id.nil?, "Bar is still associated with parent"
  end

  test "belongs_to read" do
    test_string = "marker"
    f = Foo.new(:title_t => test_string)
    f.save

    # bypass normal assignment logic so we can focus on read
    bar = Bar.new()
    bar.foo_id = f.id
    bar.save

    assert !bar.foo.nil?, "parent should have been assigned"
    assert bar.foo.title_t == test_string, "belongs_to lookup failed"
  end

  test "belongs_to assign before save" do
    test_string = "something"
    f = Foo.new(:title_t => test_string)
    f.save
    bar = Bar.new()

    bar.foo = f
    bar.save

    p2 = Foo.find(f.id)
    assert p2.bar == bar, "record wasn't associated via belongs_to"
  end

  test "belongs_to assign after save" do
    test_string = "something"
    f = Foo.new(:title_t => test_string)
    f.save
    bar = Bar.new()

    bar.save
    bar.foo = f

    p2 = Foo.find(f.id)
    assert p2.bar.nil?, "Bar should not have been automatically saved"
  end

  test "belongs_to assign to nil" do
    test_string = "something"
    f = Foo.new(:title_t => test_string)
    f.save
    bar = Bar.new()
    bar.foo = f
    bar.save

    ref = Bar.find(bar.id)
    assert !ref.foo.nil?, "Parent object should not be nil"
    assert ref.foo = f, "Parent object wasn't properly assigned"

    bar.foo = nil
    bar.save

    ref = Bar.find(bar.id)
    assert ref.foo.nil?, "Parent object should have been erased"
  end

  test "belongs_to object cache" do
    test_string = "123"
    changed_string = "456"
    f = Foo.new(:title_t => test_string)
    c = Bar.new
    f.bar = c
    f.save

    # cache the parent
    c.foo

    f.title_t = changed_string
    f.save

    assert c.foo.title_t == changed_string, "belongs_to object did not get updated"
  end

  test "belongs_to with no record" do
    bar = Bar.new
    assert bar.foo.nil?, "(unsaved record) empty belongs_to should be nil"

    bar.save
    assert bar.foo.nil?, "(saved record) empty belongs_to should still be nil"
  end

  test "has_many read" do
    f = Foo.new(:title_t => "parent")
    b1 = Baz.new(:title_t => "first child")
    b2 = Baz.new(:title_t => "second child")
    f.save

    # bypass assocaition logic for this test because we're interested in read not write.
    b1.foo_id = f.id
    b1.save
    b2.foo_id = f.id
    b2.save

    assert f.baz.map { |x| x.title_t }.sort == ["first child", "second child"]
  end

  test "has_many read one child" do
    f = Foo.new(:title_t => "parent")
    b = Baz.new(:title_t => "first child")
    f.save

    # bypass assocaition logic because we're interested in read not write.
    b.foo_id = f.id
    b.save

    assert f.baz.is_a?(Array), "attribute should be an array"
    assert f.baz[0] == b, "has_many object not found"
  end

  test "has_many assign before save" do
    test_string = "made up string"
    f = Foo.new(:title_t => "parent")
    b = Baz.new(:title_t => test_string)

    f.baz = [b]
    assert !f.instance_variable_get("@unsaved_associations")[:baz].nil?, \
        "baz isn't being tracked as unsaved"
    f.save
    assert f.instance_variable_get("@unsaved_associations")[:baz].nil?, \
        "baz is still being tracked as unsaved after save"

    assert b.foo_id == f.id, "baz was not associated with parent"
    assert b.persisted?, "baz was not saved when parent was"
  end

  test "has_many assign expects array after save" do
    f = Foo.new(:title_t => "parent")
    b = Baz.new(:title_t => "child")

    f.save
    assert_raise(NoMethodError) { f.baz = b }
  end

  test "has_many assign expects array before save" do
    f = Foo.new(:title_t => "parent")
    b = Baz.new(:title_t => "child")

    # unforuntately there's no way to validate during assignment because
    # baz is simply cached until save occurs
    f.baz = b
    assert_raise(NoMethodError) { f.save }
  end

  test "has_many assign after save" do
    test_string = "made up string"
    f = Foo.new(:title_t => "parent")
    b = Baz.new(:title_t => test_string)

    f.save
    f.baz = [b]

    assert b.foo_id == f.id, "baz was not associated with parent"
    assert b.persisted?, "baz was not saved when parent was"
  end

  test "has_many objects get cached" do
    f = Foo.new(:title_t => "parent")
    b1 = Baz.new(:title_t => "baz 1")
    b2 = Baz.new(:title_t => "baz 2")

    f.baz = [b1]
    f.save

    # cause baz to be cached by referencing it
    f.baz

    # change baz in a different object
    f2 = Foo.find(f.id)
    f2.baz = [b1, b2]

    f.baz

    assert f.baz == [b1, b2], "has_many association was not updated"

    f3 = Foo.find(f.id)

    assert f3.baz == [b1, b2], "reloaded has_many did not reflect changes"
  end

  test "has_many with no record" do
    f = Foo.new(:title_t => "parent")
    assert f.baz == [], "(unsaved record) empty has_many should be empty array"

    f.save
    assert f.baz == [], "(saved record) empty has_many should still be empty array"
  end

  test "has_many re-assignment" do
    f = Foo.new(:title_t => "parent")
    b1 = Baz.new(:title_t => "baz 1")
    b2 = Baz.new(:title_t => "baz 2")

    f.baz = [b1]
    f.save

    assert Baz.find(b1.id).foo_id == f.id, "object was not referenced"
    f.baz = [b2]

    assert Baz.find(b1.id).foo_id.nil?, "old object was not de-referenced"
  end

  test "has_many with params" do
    f = Foo.new(:title_t => "parent")
    b1 = Baz.new(:title_t => "baz 1")
    b2 = Baz.new(:title_t => "baz 2")

    f.baz = [b1, b2]
    f.save

    # reload foo and query for all baz
    f = Foo.find(f.id)
    res = f.baz
    assert res.length == 2, "wrong number of obejcts retrieved"

    # reload foo and query for one baz per page
    f = Foo.find(f.id)
    res = f.baz({:per_page => 1})
    assert res.length == 1, "too many obejcts retrieved"

    # reload foo and query for one baz
    f = Foo.find(f.id)
    res = f.baz({:rows => 1})
    assert res.length == 1, "too many obejcts retrieved"
  end

  test "has many re-assign overlapping values" do
    # this test ensures that assigning a mix of old and new objects to a has-many
    # association does not alter objects that persist across the change
    f = Foo.new(:title_t => "parent")
    b1 = Baz.new(:title_t => "baz 1")
    b2 = Baz.new(:title_t => "baz 2")
    b3 = Baz.new(:title_t => "baz 2")

    f.baz = [b1, b2]
    f.save

    assert Foo.find(f.id).baz == [b1, b2], "objects were not referenced"
    f.baz = [b1, b3]

    assert Foo.find(f.id).baz == [b1, b3], "objects were not referenced"
    assert Baz.find(b2.id).foo_id.nil?, "old object was not de-referenced"
  end

  test "has many append" do
    f = Foo.new(:title_t => "parent")
    b1 = Baz.new(:title_t => "baz 1")
    b2 = Baz.new(:title_t => "baz 2")
    b3 = Baz.new(:title_t => "baz 3")

    f.baz = []
    f.baz <<= b1
    f.baz <<= b2
    f.save
    f.baz <<= b3

    assert Foo.find(f.id).baz.length == 3, "not all child objects were saved"
  end

  test "has_many assign to nil" do
    f = Foo.new(:title_t => "parent")
    baz = Baz.new(:title_t => "baz 1")

    f.baz = [baz]
    f.save

    assert Baz.find(baz.id).foo_id == f.id, "object was not referenced"
    f.baz = []

    assert Baz.find(baz.id).foo_id.nil?, "old object was not de-referenced"
  end

  test "mass assign attrs" do
    # This behavior technically differs from ActiveModel because that would raise
    # a MassAssignmentSecurity exception. Persisted model supresses rogue attrs silently.
    f = Foo.new(:invalid => "just making sure")
    assert f.attributes.keys.sort == ["id", "title_t"], "invalid attribute was mass assignable"
  end

  test "unsaved has_many :through" do
    x = ObjX.new(:title_t => "X obj")
    y1 = ObjY.new(:title_t => "Y obj 1")
    y2 = ObjY.new(:title_t => "Y obj 2")
    z1 = ObjZ.new(:title_t => "Z obj 1")
    z2 = ObjZ.new(:title_t => "Z obj 2")
    z3 = ObjZ.new(:title_t => "Z obj 3")

    x.obj_y = [y1, y2]
    y1.obj_z = [z1, z2]
    y2.obj_z = [z3]

    # this is taking advantage of the unsaved attribute cache
    assert x.obj_z.map {|o| o.title_t}.sort == ["Z obj 1", "Z obj 2", "Z obj 3"]
  end

  test "saved has_many :through" do
    x = ObjX.new(:title_t => "X obj")
    x.save
    y1 = ObjY.new(:title_t => "Y obj 1")
    y2 = ObjY.new(:title_t => "Y obj 2")
    z1 = ObjZ.new(:title_t => "Z obj 1")
    z2 = ObjZ.new(:title_t => "Z obj 2")
    z3 = ObjZ.new(:title_t => "Z obj 3")

    x.obj_y = [y1, y2]
    y1.obj_z = [z1, z2]
    y2.obj_z = [z3]

    # compare titles only because comparing objects will confuse the assert
    assert x.obj_z.map {|o| o.title_t}.sort == ["Z obj 1", "Z obj 2", "Z obj 3"]
  end

  test "can't assign through has_many" do
    x = ObjX.new
    z = ObjZ.new
    exc = assert_raise(PersistedModelExceptions::IndirectAssociationAssignment) {
      x.obj_z = [z]
    }
    assert exc.message == "Can't assign 'obj_z' because it is indirectly associated through 'obj_y'"
    true
  end

  test "overridden methods aern't reassigned" do
    p = OParent.new
    assert p.o_child == "custom reader", "reader was re-assigned by has_one"
    assert p.o_sub_child == "custom reader", "indirect reader was re-assigned by has_one"

    c = OChild.new
    p.o_child = c
    assert p.instance_variable_get("@test_value") == c, "writer was re-assigned by has_one"

    # normally this would not be allowed because default writer forbids assignment
    s = OSubChild.new
    p.o_sub_child = s
    assert p.instance_variable_get("@test_value") == s, "indirect writer was re-assigned by has_one"
  end

  test "auto_save false" do
    x = SaveX.new
    y = SaveY.new

    x.save_y = [y]
    x.save
    assert x.persisted?, "x should have been persisted"
    assert !y.persisted?, "y should not have been persisted"
    y.save
    assert y.persisted?, "y should have been persisted"
  end

  test "delete deps upon delete" do
    p = DParent.new
    c = DChild.new
    p.save
    p.d_child = c
    assert p.persisted?, "parent was not saved"
    assert c.persisted?, "child was not saved"

    p.destroy
    assert DParent.find(p.id).nil?, "Parent was not destroyed"
    assert DChild.find(c.id).nil?, "dependent child was not destroyed"
  end

  test "delete deps upon re-assign" do
    p = DParent.new
    c1 = DChild.new
    c2 = DChild.new
    p.save
    p.d_child = c1
    assert p.persisted?, "Parent was not saved"
    assert c1.persisted?, "dependent child was not saved"

    p.d_child = c2
    assert DChild.find(c1.id).nil?, "dependent child was not destroyed"
  end

  test "belongs to deps get ignored" do
    p = DParent.new
    c = DChild.new
    p.d_child = c
    p.save

    assert p.persisted?, "Parent was not saved"
    assert c.persisted?, "dependent child was not saved"

    c.destroy
    assert p.persisted?, "Parent was destroyed"
  end

  test 'has_one memory leak' do
    f = Foo.new
    bar = Bar.new
    # there can be class level crud because class level caching uses weakref.
    bar.class.instances.clear
    f.bar = bar
    f.save

    assert bar.class.instances == {bar.id => bar}, "object wasn't cached"

    bar2 = Bar.new
    f.bar = bar2

    assert bar.class.instances == {bar2.id => bar2}, "old object wasn't deleted"

    f.bar = nil

    assert bar.class.instances == {}, "There shouldn't be any stored objects."
  end
end

# implement destroy instead of nullify codepath
# implement some sort of mark-as-dirty mechanism
