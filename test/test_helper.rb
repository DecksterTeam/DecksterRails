ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # built in fixtures breaks activerecord-tableless. use factories instead

  def reset_solr
    Mtheory::Solr::delete_all_records
  end

  def setup
    reset_solr
  end

end
