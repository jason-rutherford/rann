require 'spec_helper'

describe Network do

  describe "initializer" do
    it "initializes a network with layers and connects them" do
      layer_sizes = [2,4,1]
      n = Network.new({size: layer_sizes})
      
      expect(n.layers.count).to eq 3
      expect(n.layers[0].neurons.count).to eq 2
      expect(n.layers[1].neurons.count).to eq 4
      expect(n.layers[2].neurons.count).to eq 1

      expect(n.layers[0].neurons[0].connections.count).to eq 4
      expect(n.layers[0].neurons[1].connections.count).to eq 4
      
      expect(n.layers[0].neurons[1].incoming.count).to eq 0
      expect(n.layers[0].neurons[1].outgoing.count).to eq 4

      expect(n.layers[1].neurons[0].incoming.count).to eq 2
      expect(n.layers[1].neurons[0].outgoing.count).to eq 1
      # probably sufficient
    end
  end

  it "feeds input array through the a layer and returns output array"  do
    layer_sizes = [2,3,4]
    inputs = [1,2]
    n = Network.new({size: layer_sizes})

    # force neurons to fire
    n.layers[0].neurons[0].fire_threshold = 0
    n.layers[0].neurons[1].fire_threshold = 0
    n.layers[1].neurons[0].fire_threshold = 0
    n.layers[1].neurons[1].fire_threshold = 0
    n.layers[1].neurons[2].fire_threshold = 0

    # we will make sure feed() and n.output() returns the same thing
    output_from_feed = n.feed(inputs)
    output_from_network = n.output

    # first make sure they are equal, then just test one further
    expect(output_from_feed).to eq output_from_network 
    expect(output_from_feed).to be_an_instance_of Array
    expect(output_from_feed.count).to eq layer_sizes.last
    expect(output_from_feed.first).to be_an_instance_of Float
  end
end