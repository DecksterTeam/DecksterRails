class Geo
  attr_accessor :lat, :long

  def initialize lat, long
    @lat = lat
    @long = long
  end

  def self.parse value
    values = value.split ','
    Geo.new values[0], values[1]
  end

  def to_s
    "#{@lat},#{@long}"
  end
end