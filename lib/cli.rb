require 'pry'

class Cli

# Creates a map and then a rover
  def call
    create_map
    create_rover
  end

# creates a map of a certain size
  def create_map
    puts "Enter size of map (x, y) or (x y):"
    input = gets.chomp
    size_array = input.split(/,|\s/)

    size_array.map!(&:to_i) if /\d/
    if size_array.size != 2 && !all_integers(size_array)
      puts "Wrong arguments"
      return create_map
    end
    puts "x-axis size = #{size_array[0]} and y-axis size = #{size_array[1]} [y/n]?"

    # User can redo the input if they did the wrong format
    create_map if !input_ok?

    Map.new(size_array[0], size_array[1])
  end

  def create_rover
    puts "Enter starting points and direction of a Rover (x, y, [n,s,e,w]) or (x y [n,s,e,w]):"

    input = gets.chomp
    rover_attr = input.split(/,|\s/)

    if rover_attr.size != 3
      puts "Wrong number of arguments"
      return create_rover
    end
    dir = /n|s|e|w/i.match('k').to_s if !!/n|s|e|w/i.match(rover_attr.last)
    rover_attr.pop
    rover_attr.map!(&:to_i) if rover_attr.all

    Rover.new(rover_attr[0].to_i, rover_attr[1].to_i, rover_attr[2])
  end

  def get_movement
    puts "Enter string for how you would like the rover to move:"

    input = gets.chomp
    movement = input.chars
    binding.pry

  end

  def all_integers?(array)
    array.all? {|i| i.is_a?(Integer) }
  end

  def input_ok?
    puts "Input ok?"
    input = gets.chomp
    if /y|n/i.match(input)
      /n/i.match(input) ? false : true
    else
      puts "Try again"
      input_ok?
    end
  end

end
