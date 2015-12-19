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

      # connected layers should have a bias neuron
      expect(n.layers[0].bias).to be_an_instance_of Neuron

      # input layer
      expect(n.layers[0].neurons[0].incoming.count).to eq 0
      expect(n.layers[0].neurons[0].outgoing.count).to eq 4

      expect(n.layers[0].neurons[1].incoming.count).to eq 0
      expect(n.layers[0].neurons[1].outgoing.count).to eq 4

      # hidden layer
      expect(n.layers[1].neurons[0].incoming.count).to eq 3 # includes bias
      expect(n.layers[1].neurons[0].outgoing.count).to eq 1

      # output layer
      expect(n.layers[2].neurons[0].incoming.count).to eq 5 # includes bias
      expect(n.layers[2].neurons[0].outgoing.count).to eq 0
      # probably sufficient
    end

    it "initializes a network with layers and connects them using a forced weight" do
      layer_sizes = [1, 2]
      n = Network.new({size: layer_sizes, force_weight: 0.12})
      
      expect(n.layers.count).to eq 2
      expect(n.layers[0].neurons[0].outgoing[0].weight).to eq 0.12
      expect(n.layers[1].neurons[0].incoming[0].weight).to eq 0.12
      expect(n.layers[1].neurons[1].incoming[0].weight).to eq 0.12
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