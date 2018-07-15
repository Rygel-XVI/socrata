
RSpec.describe Map do

  it 'is defined' do
    expect(defined?(Map)).to be_truthy
    expect(Map).to be_a(Class)
  end


  it "initializes with a map size" do
    map = Map.new(5, 5)
    expect(map.x).to eq(5)
    expect(map.y).to eq(5)
  end

end
