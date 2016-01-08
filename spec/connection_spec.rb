require 'spec_helper'

describe Connection do
  def default_setup
    @n1 = Neuron.new
    @n2 = Neuron.new
    @c = Connection.new(@n1, @n2)
  end

  it 'takes parameters and returns a Connection' do
    default_setup
    expect(@c).to be_an_instance_of Connection
  end

  it 'initializes with valid default weights' do
    default_setup
    expect(@c.weight).to be >= -0.5
    expect(@c.weight).to be <= 0.5
  end

  it 'can be initialized with specific weight' do
    @c = Connection.new(@n1, @n2, 2.5)
    expect(@c.weight).to eq 2.5
  end

  it 'can set new weight by a factor of it' do
    @c = Connection.new(@n1, @n2, 0.5)
    @c.weight_by_factor(3)
    expect(@c.weight).to eq 1.5
  end
end
