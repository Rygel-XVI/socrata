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
    input = gets.chomp

    abort if quit?(input)
    size_array = input.split(/,|\s/)

    size_array.map!(&:to_i)
    if !size_array.all? { |i| i > 0 } || size_array.size != 2
      puts "Wrong arguments"
      return create_map
    end

    puts "x-axis size = #{size_array[0]} and y-axis size = #{size_array[1]} [y/n]?"

    # User can redo the input if they did the wrong format
    puts "Input ok?"
    create_map if !input_ok?

    Map.new(size_array[0], size_array[1])
  end

  def create_rover
    puts "Enter starting points and direction of a Rover (x, y, [n,s,e,w]) or (x y [n,s,e,w]):"

    input = gets.chomp
    abort if quit?(input)
    rover_attr = input.split(/,|\s/)

    ## Checks that there are 3 arguments else reruns code
    if rover_attr.size != 3
      puts "Bad input"
      return create_rover
    end

    ## Checks that input is ok for the direction and reruns method elsewise
    if !!/n|s|e|w/i.match(rover_attr.last)
      dir = /n|s|e|w/i.match(rover_attr.last).to_s
      rover_attr.pop
    else
      puts "Bad input try again"
      return create_rover
    end

    ## Checks that the axis inputs are integers and reruns code elsewise
    rover_attr.map!(&:to_i)
    if !rover_attr.all? { |i| i > 0 }
      puts "Bad input try again"
      return create_rover
    end

    puts "Input ok?"
    Rover.new(rover_attr[0], rover_attr[1], dir) if input_ok?

    #sets rover.map
    Rover.all.last.map = Map.all.last
    get_movement
  end

  def get_movement
    puts "Enter string for how you would like the rover to move (L, R, M):"
    input = gets.chomp
    abort if quit?(input)
    input.downcase!
    move_array = input.split("")
    if !move_array.all? { |i| /L|M|R/i.match?(i) }
      puts "Bad input try again"
      return get_movement
    else
      move_rover(move_array)
    end
  end

# Have to add selection of rover options and selection if this were a bigger program
  def move_rover(move_array)
    Rover.all.last.move_me(move_array)
    puts "Move another rover?"
    create_rover if input_ok?
    abort
  end

# returns boolean if user likes input or reruns code
  def input_ok?
    input = gets.chomp
    abort if quit?(input)
    if /y|n/i.match(input)
      /n/i.match(input) ? false : true
    else
      puts "Try again"
      input_ok?
    end
  end

  def quit?(input)
    /quit/i.match(input)
  end

end
