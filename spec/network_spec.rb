require 'spec_helper'

describe Network do
  describe 'initializer' do
    it 'initializes a network with layers and connects them' do
      layer_sizes = [2, 4, 1]
      n = Network.new(size: layer_sizes)

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

    it 'initializes a network with layers and connects them using a forced weight' do
      layer_sizes = [1, 2]
      n = Network.new(size: layer_sizes, force_weight: 0.12)

      expect(n.layers.count).to eq 2
      expect(n.layers[0].neurons[0].outgoing[0].weight).to eq 0.12
      expect(n.layers[1].neurons[0].incoming[0].weight).to eq 0.12
      expect(n.layers[1].neurons[1].incoming[0].weight).to eq 0.12
    end
  end

  it 'activate input array through the network and returns output array' do
    layer_sizes = [2, 3, 4]
    inputs = [1, 2]
    n = Network.new(size: layer_sizes, force_weight: 0.4)

    # we will make sure activate() and n.output() returns the same thing
    output_from_activate = n.activate(inputs)
    output_from_network = n.output

    # first make sure they are equal, then just test one further
    expect(output_from_activate).to eq output_from_network
  end

  it 'size 1,1 returns valid output after activate([1,1])' do
    layer_sizes = [1, 1]
    inputs = [1, 1]
    n = Network.new(size: layer_sizes, force_weight: 0.4)

    # freshly initialized network output should be an array of nils foreach output layer neuron
    expect(n.output).to eq [0]

    # we will make sure activate() and n.output() returns the same thing
    output_from_activate = n.activate(inputs)
    output_from_network = n.output

    # first make sure they are equal, then just test one further
    expect(output_from_activate).to eq output_from_network
    expect(output_from_activate).to be_an_instance_of Array
    expect(output_from_activate.count).to eq layer_sizes.last
    expect(output_from_activate.first).to be_an_instance_of Float
    expect(output_from_activate.first).to eq 0.6665058141357768
  end

  it 'size 2,2 returns valid output after activate([1,1])' do
    layer_sizes = [2, 2]
    inputs = [1, 1]
    n = Network.new(size: layer_sizes, force_weight: 0.4)

    # freshly initialized network output should be an array of nils foreach output layer neuron
    expect(n.output).to eq [0, 0]

    # we will make sure activate() and n.output() returns the same thing
    output_from_activate = n.activate(inputs)
    output_from_network = n.output

    # first make sure they are equal, then just test one further
    expect(output_from_activate).to eq output_from_network
    expect(output_from_activate).to be_an_instance_of Array
    expect(output_from_activate.count).to eq layer_sizes.last
    expect(output_from_activate[0]).to be_an_instance_of Float
    expect(output_from_activate[0]).to eq 0.728068880540669
    expect(output_from_activate[1]).to eq 0.728068880540669
  end

  it 'activate returns the same as newtork.output' do
    layer_sizes = [1, 1]
    inputs = [3, 4]
    n = Network.new(size: layer_sizes)

    output_from_activate = n.activate(inputs)
    output_from_network = n.output

    expect(output_from_activate).to eq output_from_network
  end
end
