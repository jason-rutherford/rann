class Network

  attr_accessor :layers

  def initialize(options={})
    self.layers = []
    self.build_layers(options[:size]) if options[:size]
    connect
  end

  def build_layers(size)
    size.each do |neuron_count|
      self.layers << Layer.new({neurons: neuron_count})
    end
  end

  def connect
    layers.each_with_index do |layer, idx|
      layer.connect(layers[idx+1]) if idx+1 < layers.count
    end
  end

  def feed(inputs)
    input_layer.feed(inputs)
    output_layer.output
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

  def to_s
    "Network" + 
    layers.join("\n ").to_s 
  end

end