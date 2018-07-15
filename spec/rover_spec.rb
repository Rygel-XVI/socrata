
RSpec.describe Rover do

  it 'is defined' do
    expect(defined?(Rover)).to be_truthy
    expect(Rover).to be_a(Class)
  end


  it "initializes with a location and direction" do
    rover = Rover.new(1, 1, "n")

    expect(rover.x).to eq(1)
    expect(rover.y).to eq(1)
    expect(rover.direction).to eq("n")
  end

  it "spins to the left and right" do
    rover = Rover.new(1, 1, "n")

    rover.spin_left
    rover.direction == "e"
    rover.spin_left
    rover.direction == "s"
    rover.spin_right
    rover.direction == "e"
  end

  it "moves properly" do
    rover = Rover.new(1, 1, "n")
    rover.map = Map.all.first

    rover.move
    expect(rover.x).to eq(1)
    expect(rover.y).to eq(2)
    rover.spin_right
    rover.move
    expect(rover.x).to eq(2)
    expect(rover.y).to eq(2)
  end

  it "checks for valid moves" do
    rover = Rover.new(1, 5, "n")
    rover.map = Map.all.first
    expect(rover.y).to eq(5)
    expect(rover.x).to eq(1)

    rover1 = Rover.new(4, 0, "s")
    rover.map = Map.all.first
    expect(rover1.y).to eq(0)
    expect(rover1.x).to eq(4)

    rover2 = Rover.new(5, 2, "e")
    rover.map = Map.all.first
    expect(rover2.y).to eq(2)
    expect(rover2.x).to eq(5)

    rover3 = Rover.new(0, 0, "w")
    rover.map = Map.all.first
    expect(rover3.y).to eq(0)
    expect(rover3.x).to eq(0)
  end

end
