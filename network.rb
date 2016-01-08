require './layer.rb'
require './trainer.rb'
# This class handles building network of layers with neurons and connections.  It can receive inputs and return outputs.
# It can be trained.
class Network
  attr_accessor :layers, :options, :hidden_layers

  def initialize(options = {})
    @layers = []
    @hidden_layers = []
    @options = {}

    @options.merge! options
    @options[:size] = [1, 2, 1] if options[:size].nil?

    build_layers
    connect
  end

  def connect
    layers.each_with_index do |layer, idx|
      layer.connect(layers[idx + 1]) if idx + 1 < layers.count
    end
  end

  def activate(inputs)
    input_layer.activate(inputs)
    hidden_layers.each(&:activate)
    output_layer.activate
  end

  def input_layer
    layers.first
  end

  def output_layer
    layers.last
  end

  def output
    output_layer.output
  end

  def train(expected_array)
    output_layer.train(expected_array)
    hidden_layers.reverse_each(&:train)
    input_layer.train
  end

  # in case we want to see normal inspect, because we are going to override it below
  (alias_method :inspect_normal, :inspect) unless $reloading

  # now lets override inspect to a something better formatted
  def inspect
    to_s
  end

  def to_s
    puts 'Network' + layers.join("\n ").to_s
  end

  private

  def build_layers
    options[:size].each do |neuron_count|
      opts = { neurons: neuron_count }
      opts[:force_weight] = options[:force_weight] if options[:force_weight]
      layers << Layer.new(opts)
    end

    # layer's default to type hidden
    input_layer.type = :input
    output_layer.type = :output
    @hidden_layers = layers.slice(1, layers.size - 2)
  end
end
