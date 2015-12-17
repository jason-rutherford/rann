require './neuron.rb'

class Layer

  attr_accessor :type, :neurons, :options

  def initialize(options={})
    self.options = options
    self.type = options[:type] ? options[:type].to_sym : :hidden
    self.neurons = []
    build_neurons
  end

  def build_neurons
    neurons_or_count = self.options[:neurons]
    case neurons_or_count
    when Integer
      neurons_or_count.times do
        opts = {}
        opts.merge!({force_weight: self.options[:force_weight]}) if self.options[:force_weight]
        self.neurons << Neuron.new(opts)
      end
    when Array
      raise StandardError.new('Layer neurons are not all of Neuron class') if neurons_or_count.collect { |n| !n.is_a?(Neuron)}.any?
      self.neurons = neurons_or_count
    end
  end

  # connects this layer neurons (sources) to another layer neurons (targets)
  def connect(target_layer)
    neurons.each do |n|
      n.connect(target_layer.neurons)
    end
  end

  def feed(inputs)
    outputs = []
    neurons.each_with_index do |neuron, idx|
      outputs << neuron.activate(inputs[idx])
    end
    outputs
  end

  def output
    self.neurons.collect { |n| n.output }
  end

  def to_s
    "\n #{self.type.capitalize} Layer #{object_id}\n" +
    "  " + neurons.join("\n  ").to_s
  end

end