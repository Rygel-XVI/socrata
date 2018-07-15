require 'pry'

class Socrata::Cli

# Creates a map and then a rover
  def call
    create_map
    create_rover
  end

# creates a map of a certain size
  def create_map
    puts "Enter size of map (x, y) or (x y):"
    input = gets.strip

    abort if quit?(input)
    size_array = input.split(/,|\s/)

    size_array.map!(&:to_i)
    if size_array.size == 2 && greater_than_zero?(size_array)
      Socrata::Map.new(size_array[0], size_array[1])
    else
      puts "Wrong arguments"
      create_map
    end
#########removed challenge doesn't have this line of input =)
    # puts "x-axis size = #{size_array[0]} and y-axis size = #{size_array[1]} [y/n]?"

    # User can redo the input if they did the wrong format
    # puts "Input ok?"
    # create_map if !input_ok?
  end

  def greater_than_zero?(array)
    array.all? {|i| i > 0 }
  end

  def create_rover
    puts "Enter starting points and direction of a Rover (x, y, [n,s,e,w]) or (x y [n,s,e,w]):"

    input = gets.strip.downcase
    abort if quit?(input)
    rover_attr = input.split(/,|\s/)

# Checks that the input has the appropriate number of items and that the initial direction is valid.
    if rover_attr.size == 3 && initial_direction_valid?(rover_attr)
      dir = rover_attr.last.to_s
      rover_attr.pop
      rover_attr.map!(&:to_i)
    else
      puts "Bad Input"
      return create_rover
    end

# Checks if the coordinates are on the map
    if !coord_within_map?(rover_attr)
      puts "Bad Input"
      return create_rover
    end

    # !array_has_zero?(rover_attr) &&

    Socrata::Rover.new(rover_attr[0], rover_attr[1], dir)
    puts "Made rover starting at x: #{rover_attr[0]}, y: #{rover_attr[0]}, pointing: #{dir}"
    # Socrata::Rover.new(rover_attr[0], rover_attr[1], dir)


#########removed challenge doesn't have this line of input =)
    # puts "Input ok?"
    # create_rover if !input_ok?

    #sets rover.map to the map just created
    Socrata::Rover.all.last.map = Socrata::Map.all.last
    get_movement
  end

## Queries for string for movement pattern. sanitizes and then calles method to move rover
  def get_movement
    puts "Enter string for how you would like the rover to move (L, R, M):"
    input = gets.strip.downcase
    abort if quit?(input)
    # input.downcase!
    move_array = input.split("")
    if !move_array.all? { |i| /L|M|R/i.match?(i) }
      puts "Bad input try again"
      get_movement
    else
#########removed challenge doesn't have this line of input =)
      # !input_ok? ? move_rover(move_array) : get_movement
      move_rover(move_array)
    end
  end

# Have to add selection of rover options and selection if this were a bigger program
  def move_rover(move_array)
    Socrata::Rover.all.last.move_me(move_array)
#########removed challenge doesn't have this line of input =)
    # puts "Move another rover?"
    # create_rover if input_ok?
    create_rover if Socrata::Rover.all.size < 2

    abort
  end


#########removed challenge doesn't have this line of input =)

# returns boolean if user likes input or reruns code
  # def input_ok?(input)
  #   # input = gets.strip
  #   abort if quit?(input)
  #   if /y|n/i.match(input)
  #     /n/i.match(input) ? false : true
  #   else
  #     puts "Try again"
  #     input_ok?
  #   end
  # end

  def quit?(input)
    /quit/i.match(input)
  end

# Checks if a number in the array is zero. input should be array of integers
  def array_has_zero?(array)
    array.all? { |i| i > 0 }
  end

# checks if the numbers in the array are on the map
  def coord_within_map?(array)
    map = Socrata::Map.all.last
    if array.first <= map.x && array.first >= 0 && array.last <= map.y && array.last >= 0
      true
    else
      false
    end
  end

# checks that the initial direction given is an actualy direction
  def initial_direction_valid?(rover_attr)
    case rover_attr.last
    when "n", "s", "e", "w"
      true
    else
      false
    end
  end

end
