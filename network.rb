require './layer.rb'

class Network
  
  attr_accessor :layers, :options, :hidden_layers

  def initialize(options={})
    self.layers = []
    self.hidden_layers = []
    self.options = {}
    

    self.options.merge! options
    self.options[:size] = [1,2,1] if options[:size].nil?

    build_layers
    connect
  end

  def connect
    layers.each_with_index do |layer, idx|
      layer.connect(layers[idx+1]) if idx+1 < layers.count
    end
  end

  def activate(inputs)
    input_layer.activate(inputs)
    hidden_layers.each { |layer| layer.activate }
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

 # in case we want to see normal inspect, because we are going to override it below
  (alias_method :inspect_normal, :inspect) unless $reloading

  # now lets override inspect to a something better formatted
  def inspect
    to_s
  end

  def to_s
    puts "Network" + layers.join("\n ").to_s
  end

  private

  def build_layers
    
    self.options[:size].each do |neuron_count|
      opts = {neurons: neuron_count}
      opts[:force_weight] = self.options[:force_weight] if self.options[:force_weight]
      self.layers << Layer.new(opts)
    end

    # layer's default to type hidden
    input_layer.type = :input
    output_layer.type = :output
    self.hidden_layers = layers.slice(1,layers.size-2)
  end

end