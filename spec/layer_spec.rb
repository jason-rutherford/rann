require 'spec_helper'

describe Layer do

  it 'initializes with options' do
    l = Layer.new({type: :input})
    expect(l.type).to eq :input
  end

  it 'initializes with options for building neurons' do
    # initializes and builds X many neurons
    l = Layer.new({type: :input, neurons: 4})
    expect(l.neurons.count).to eq 4

    # initializes with a specified neurons array
    neurons = []
    5.times do
      neurons << Neuron.new
    end
    l = Layer.new({type: :input, neurons: neurons})
    expect(l.neurons.count).to eq 5
  end

  it 'raises if neurons are not of class neurons' do   
    neurons = [Neuron.new, :b, :c]
    expect { Layer.new({type: :input, neurons: neurons}) }.to raise_error('Layer neurons are not all of Neuron class')
  end

  it 'receives a custom set of neurons' do
    l = Layer.new({type: :input})
    neurons = []
    6.times do
      neurons << Neuron.new
    end
    l.neurons = neurons
    expect(l.neurons).to eq neurons
  end

  it 'builds a number of neurons into itself' do
    l = Layer.new({type: :input, neurons: 10})
    expect(l.neurons.count).to eq 10
  end

  it 'connects each neuron in layer1 to every neuron in layer2' do
    Neuron.reset_counter
    l1 = Layer.new({type: :input, neurons: 3})
    l2 = Layer.new({type: :input, neurons: 3})
    l1.connect(l2)
    
    expect(l1.neurons[0].outgoing.count).to eq 3
    expect(l1.neurons[1].outgoing.count).to eq 3
    expect(l1.neurons[2].outgoing.count).to eq 3

    expect(l2.neurons[0].incoming.count).to eq 3
    expect(l2.neurons[1].incoming.count).to eq 3
    expect(l2.neurons[2].incoming.count).to eq 3
  end


  it 'connects each neuron in layer1 to every neuron in layer2 with specific connection weights' do
    Neuron.reset_counter
    l1 = Layer.new({type: :input, neurons: 2, force_weight: 0.3})
    l2 = Layer.new({type: :input, neurons: 2})
    l1.connect(l2)
    
    expect(l1.neurons[0].outgoing[0].weight).to eq 0.3
    expect(l1.neurons[1].outgoing[1].weight).to eq 0.3
   
    expect(l2.neurons[0].incoming[0].weight).to eq 0.3
    expect(l2.neurons[1].incoming[1].weight).to eq 0.3
  end


  it 'feeds with input array and returns output array' do
    input = [1,2,3]
    l1 = Layer.new({type: :input, neurons: 1})
    output = l1.feed(input)
    expect(output).to be_instance_of Array
    expect(output.count).to eq 1

    input = [1,2,3]
    l1 = Layer.new({type: :input, neurons: 2})
    output = l1.feed(input)
    expect(output).to be_instance_of Array
    expect(output.count).to eq 2
    # should be sufficient
  end

end