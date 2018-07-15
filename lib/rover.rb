
class Socrata::Rover

  attr_accessor :x, :y, :direction, :map

  @@all = []

  def initialize(x, y, direction)
    @x = x
    @y = y
    @direction = direction.downcase
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

  def move_me(move_array)
    case move_array.last
    when 'l'
      spin('l')
    when 'r'
      spin('r')
    when 'm'
      move
    end
    move_array.pop
    if move_array.size > 0
      move_me(move_array)
    else
      puts "Ending Coordinates X: #{self.x}, Y: #{self.y}, Pointing: #{self.direction}"
    end
  end

  def spin(dir)
    dir == "l" ? spin_left : spin_right
  end

## These methods change the direction the rover is pointing
  def spin_left
    case self.direction
    when 'n'
      self.direction = 'w'
    when 'e'
      self.direction = 'n'
    when 's'
      self.direction = 'e'
    when 'w'
      self.direction = 's'
    end
  end

  def spin_right
    case self.direction
    when 'n'
      self.direction = 'e'
    when 'e'
      self.direction = 's'
    when 's'
      self.direction = 'w'
    when 'w'
      self.direction = 'n'
    end
  end


  def move
    get_axis == 'y' ? move_vertical : move_horizontal
  end

## Methods to move the rover if it won't put the rover off the map ##
  def move_vertical
    pointing_north? ? self.y = self.y += 1 : self.y = self.y -= 1 if !(pointing_north? && at_axis_limit?('y') || pointing_south? && self.y == 0)
  end

  def move_horizontal
    pointing_east? ? self.x = self.x += 1 : self.x = self.x -= 1 if !(pointing_east? && at_axis_limit?('x') || pointing_west? && self.x == 0)
  end

## Checks if the rover is at the North or East edge of the map ##
  def at_axis_limit?(axis)
    axis == 'y' ? self.y == self.map.y : self.x == self.map.x
  end

## Checks if the rover is pointed along the x or y axis and returns the axis ##
  def get_axis
    pointing_north? || pointing_south? ? 'y' : 'x'
  end


## Methods that check which direction the rover is pointing_east ##

  def pointing_north?
    self.direction == 'n'
  end

  def pointing_south?
    self.direction == 's'
  end

  def pointing_east?
    self.direction == 'e'
  end

  def pointing_west?
    self.direction == 'w'
  end


end
