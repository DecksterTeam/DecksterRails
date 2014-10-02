require 'test_helper'

class Junk < PersistedModel
  public_attr_accessor :data_t
end

class TestEnvironmentTest < ActiveSupport::TestCase
   test "reset solr" do
     #Create some data, then reset and see if it was removed.
     dev = Junk.new(:data_t => "test")
     dev.save

     res = Junk.find(dev.id)
     assert res, "Document wasn't created. Test can't continue."

     self.reset_solr

     res = Junk.find(dev.id)
     assert_nil res, "reset_solr did not delete all documents."
   end

  test "reset solr in production" do
    env = Rails.env
    begin
      Rails.env = "production"
      assert_raise(RuntimeError) {self.reset_solr}
    ensure
      Rails.env = env
    end
  end
end
