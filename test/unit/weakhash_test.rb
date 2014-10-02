require 'test_helper'

def kill_weakrefs h, keys = nil
  keys = Array(keys) unless keys.nil?
  h.each { |key, ref|
    # if keys was nil, we want to nullify every weakref
    if keys.nil? or keys.include?(key)
      def ref.weakref_alive?
        false
      end
    end
  }
end

class DeviceTest < ActiveSupport::TestCase
  test "weak hash stores weak refs" do
    h = WeakHash.new
    h[:foo] = "foo"
    val = h.values[0]
    assert val.kind_of?(WeakRef), "assignment did not create weak reference"
  end

  test "has_key deletes cache miss" do
    # we cannot force garbage collection, so we'll fake it.
    h = WeakHash.new
    h[:foo] = "foo"

    # we can't force garbage collection to occur, so override the alive check
    kill_weakrefs h
    assert h.keys == [:foo], "cache should have a key for foo"
    assert h.has_key?(:foo) == false, "cache shouldn't be able to fetch foo"
    assert h.keys == [], "cache should have deleted reference to foo"
  end

  test "has_key doesn't delete cache hit" do
    h = WeakHash.new
    foo = "foo"
    h[:foo] = foo

    assert h.keys == [:foo], "cache should have a key for foo"
    assert h.has_key?(:foo) == true, "cache shouldn't be able to fetch foo"
    assert h.keys == [:foo], "cache shouldn't have deleted reference to foo"
  end

  test "index one miss and one hit" do
    h = WeakHash.new
    h[:foo] = "foo"
    h[:bar] = "bar"

    # we're also indirectly testing the validity of kill_weakrefs' logic
    kill_weakrefs(h, :foo)
    assert h[:foo].nil?, "referencing foo should return nil"
    assert !h[:bar].nil?, "bar should still be valid"
    assert h.keys == [:bar], "cache should have a key for bar"
  end

  test "index missing key" do
    h = WeakHash.new
    assert h[:foo].nil?, "missing key should have resulted in nil"
  end

  test "hash with missing key" do
    h = WeakHash.new
    assert h.has_key?(:foo) == false, "hash should not have key"
  end
end
