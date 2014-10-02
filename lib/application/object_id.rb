require 'java'

module ObjectId
  def self.new
     return java.util.UUID.randomUUID.to_s
  end
end