
class Socrata::Map

  attr_reader :x, :y

  @@all = []

  def initialize(x, y)
    @x = x
    @y = y
    save
  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all.clear
  end

  def save
    @@all << self
  end

end
