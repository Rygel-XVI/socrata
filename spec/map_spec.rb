
RSpec.describe Socrata::Map do

  it 'is defined' do
    expect(defined?(Socrata::Map)).to be_truthy
    expect(Socrata::Map).to be_a(Class)
  end


  it "initializes with a map size" do
    map = Socrata::Map.new(5, 5)
    expect(map.x).to eq(5)
    expect(map.y).to eq(5)
  end

end
