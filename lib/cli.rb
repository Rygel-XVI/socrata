require 'pry'

class Socrata::Cli

# Creates a map and then a rover
  def call
    puts "Type quit at anytime to quit"
    create_map
    create_rover
  end

# creates a map with a width and height greater than 0
  def create_map
    puts "Enter size of map (x, y) or (x y):"
    input = gets.strip

    abort if quit?(input)
    size_array = input.split(/,|\s/)

    size_array.map!(&:to_i)

    # Checks that there are two numbers greater than 0 entered before creating map
    if size_array.size == 2 && greater_than_zero?(size_array)
      Socrata::Map.new(size_array[0], size_array[1])
    else
      puts "Wrong arguments"
      return create_map
    end

  end

  def create_rover
    puts "Enter starting points and direction of a Rover (x, y, [n,s,e,w]) or (x y [n,s,e,w]):"

    input = gets.strip.downcase
    abort if quit?(input)
    rover_attr = input.split(/,|\s/)

# Checks that the input has 3 arguemnts, the direction is valid, and tha corrdinates are valid
    if rover_attr.size == 3 && initial_direction_valid?(rover_attr) && coordinates_valid?(rover_attr.first 2)
      dir = rover_attr.last
      rover_attr.pop
      rover_attr.map!(&:to_i)
    else
      puts "Bad Input"
      return create_rover
    end

    Socrata::Rover.new(rover_attr[0], rover_attr[1], dir)
    puts "Made rover starting at x: #{rover_attr[0]}, y: #{rover_attr[0]}, pointing: #{dir}"

# sets map to the rover and then calls method to set instructions for movement
    Socrata::Rover.all.last.map = Socrata::Map.all.last
    get_movement

# If 2 rovers exist then move them else create new rover
    Socrata::Rover.all.size < 2 ? create_rover : Socrata::Rover.move

  end

## Queries for string for movement pattern. sanitizes and then calles method to move rover
  def get_movement
    puts "Enter string for how you would like the rover to move (L, R, M):"
    input = gets.strip.downcase
    abort if quit?(input)
    move_array = input.split("")

    if !move_array.all? { |i| /L|M|R/i.match?(i) }
      puts "Bad input try again"
      get_movement
    else
      Socrata::Rover.all.last.movement = move_array
    end
  end

  def quit?(input)
    /quit/i.match(input)
  end

  def greater_than_zero?(array)
    array.all? {|i| i > 0 }
  end

  def coordinates_valid?(array)
    all_integers?(array)
    coord_within_map?(array)
  end

  def all_integers?(array)
    array.all?{|i| /\d/.match(i) }
  end

# checks if the numbers in the array are on the map
  def coord_within_map?(array)
    array.map!(&:to_i)
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

  ###code if it were to be more dynamic to handle user input

  # Have to add selection of rover options and selection if this were a bigger program
  #   def move_rover(move_array)
  #     Socrata::Rover.all.last.move_me(move_array)
  # #########removed challenge doesn't have this line of input =)
  #     # puts "Move another rover?"
  #     # create_rover if input_ok?
  #     create_rover if Socrata::Rover.all.size < 2
  #
  #     abort
  #   end


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

end
