require './neuron.rb'
# This class builds a layer containing neurons.  It can connect layers together through neuron connections.
class Layer
  attr_accessor :type, :neurons, :bias, :options

  def initialize(options = {})
    @options = options
    @type = options[:type] ? options[:type].to_sym : :hidden
    @neurons = []
    @bias = nil
    build_neurons
  end

  def build_neurons
    neurons_or_count = options[:neurons]
    case neurons_or_count
    when Integer
      neurons_or_count.times do
        opts = {}
        opts.merge!(force_weight: options[:force_weight]) if options[:force_weight]
        neurons << Neuron.new(opts)
      end
    when Array
      fail StandardError.new('Layer neurons are not all of Neuron class') if neurons_or_count.collect { |n| !n.is_a?(Neuron) }.any?
      @neurons = neurons_or_count
    end
  end

  # connects this layer neurons (sources) to another layer neurons (targets)
  def connect(target_layer)
    add_bias
    neurons_and_bias.each do |n|
      n.connect(target_layer.neurons)
    end
  end

  def neurons_and_bias
    neurons + [bias].compact
  end

  def activate(values = nil)
    outputs = []
    neurons_and_bias.each_with_index do |neuron, idx|
      outputs << neuron.activate(values && values[idx])
    end
    outputs
  end

  def train(target_outputs = nil)
    target_outputs = Array[target_outputs].flatten # force our splat arg to an Array

    neurons_and_bias.each_with_index do |neuron, idx|
      neuron.train(target_outputs[idx])
    end
  end

  def add_bias
    opts = { bias: true }
    opts.merge!(force_weight: options[:force_weight]) if options[:force_weight]
    @bias = Neuron.new(opts) if bias.nil?
  end

  def output
    neurons.collect(&:output)
  end

  # in case we want to see normal inspect, because we are going to override it below
  (alias_method :inspect_normal, :inspect) unless $reloading

  def inspect
    to_s
  end

  def to_s
    "\n #{type.capitalize} Layer #{object_id}\n" \
      ' ' + neurons_and_bias.join("\n  ").to_s
  end
end
