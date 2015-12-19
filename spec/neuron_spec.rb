require 'spec_helper'
 
describe Neuron do

  it 'takes no parameters and returns a Neuron' do
    n = Neuron.new
    expect(n).to be_an_instance_of Neuron
  end
 
  it 'sets an output when attempted to activate' do
    n = Neuron.new
    output = n.activate(1)
    expect(output).to be_an_instance_of Float
    expect(n.output).to eq(output)
    expect(n.output).to eq(0.7310585786300049)
  end

  it 'will default to and output 1 when it is a bias neuron' do
    n = Neuron.new(is_bias: true)
    expect(n.output).to eq 1

    output = n.activate(3)
    expect(output).to be_an_instance_of Fixnum
    expect(n.output).to eq(1)
  end

  it 'tracks and resets the current neuron count' do
    Neuron.reset_counter
    expect(Neuron.count).to eq 0

    n1 = Neuron.new
    expect(Neuron.count).to eq 1

    n2 = Neuron.new
    expect(Neuron.count).to eq 2

    Neuron.reset_counter
    expect(Neuron.count).to eq 0
  end

  describe 'connection' do
    it 'connects to a single neuron' do
      n1 = Neuron.new
      n2 = Neuron.new
      n1.connect(n2)
    
      expect(n1.outgoing.count).to eq 1
      expect(n1.incoming.count).to eq 0
      expect(n2.outgoing.count).to eq 0
      expect(n2.incoming.count).to eq 1
      
      expect(n1.outgoing.first).to be_an_instance_of Connection
      expect(n2.incoming.first).to be_an_instance_of Connection
      expect(n1.outgoing.first).to eq n2.incoming.first
    end

    it 'connects to a multiple neurons and tracks them via incoming and outgoing' do
      n1 = Neuron.new
      n2 = Neuron.new
      n3 = Neuron.new
      n1.connect(n2, n3)
    
      expect(n1.outgoing.count).to eq 2
      expect(n1.incoming.count).to eq 0
      expect(n2.outgoing.count).to eq 0
      expect(n2.incoming.count).to eq 1
      expect(n3.outgoing.count).to eq 0
      expect(n3.incoming.count).to eq 1

      expect(n1.outgoing.first).to be_an_instance_of Connection
      expect(n2.incoming.first).to be_an_instance_of Connection
      expect(n3.incoming.first).to be_an_instance_of Connection

      expect(n1.outgoing.first).to eq n2.incoming.first
      expect(n1.outgoing[1]).to    eq n3.incoming.first
    end

    it 'connects to a tree of neurons' do
      n1 = Neuron.new
      n2 = Neuron.new
      n3 = Neuron.new
      n4 = Neuron.new

      n1.connect(n2, n3, n4)
      n2.connect(n3, n4)
      n3.connect(n4)
    
      expect(n1.outgoing.count).to eq 3
      expect(n1.incoming.count).to eq 0
      expect(n2.outgoing.count).to eq 2
      expect(n2.incoming.count).to eq 1
      expect(n3.outgoing.count).to eq 1
      expect(n3.incoming.count).to eq 2
      expect(n4.incoming.count).to eq 3
      expect(n4.outgoing.count).to eq 0

      expect(n1.outgoing.first).to be_an_instance_of Connection
      expect(n2.incoming.first).to be_an_instance_of Connection
      expect(n3.incoming.first).to be_an_instance_of Connection
      expect(n4.incoming.first).to be_an_instance_of Connection

      expect(n1.outgoing[0]).to eq n2.incoming[0]
      expect(n1.outgoing[1]).to eq n3.incoming[0]
      expect(n1.outgoing[2]).to eq n4.incoming[0]

      expect(n2.outgoing[0]).to eq n3.incoming[1]
      expect(n2.outgoing[1]).to eq n4.incoming[1]
      # that's enough
    end
  end

  describe 'activation' do
    it 'sums input from incoming connections' do
      Neuron.reset_counter

      n1 = Neuron.new
      n2 = Neuron.new
      n3 = Neuron.new

      # connect_one() lets you set the weight, connect() does not
      n1.connect_one(n3, 1)
      n2.connect_one(n3, 1)

      # manually set the outputs
      n1.output = 1.5
      n2.output = 1.5

      output = n3.activate    
      expect(n3.input).to eq 3.0
    end

    it 'activates connected (outgoing) neurons when output exceeds fire threshold' do
      Neuron.reset_counter
      n1 = Neuron.new
      n2 = Neuron.new

      # override threshold so it always fires
      n1.fire_threshold = 0 
      # connect_one() lets you set the weight, connect() does not
      n1.connect_one(n2, 1)
      
      expect(n1.fired?).to be false          
      expect(n1.output).to be nil
      expect(n2.output).to be nil
      
      n1.activate(10)
      
      expect(n1.fired?).to be true
      expect(n1.output).not_to be nil
      expect(n2.output).not_to be nil
    end
  end
end