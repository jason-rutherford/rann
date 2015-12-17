require './connection.rb'

class Neuron
  
  attr_accessor :id, :options, :input, :output, :weight, :fire_threshold, :fired, :outgoing, :incoming
  @@count = 0

  def initialize(options={})
    self.options = {}
    self.input = nil
    self.output = nil
    self.fire_threshold = 0.5
    self.fired = false
    self.incoming = []
    self.outgoing = []
    self.id = @@count += 1

    self.options.merge! options
  end

  def activate(input=sum_connections)
    self.input = input
    raise "no input value was provided" if self.input.nil?
    self.output = activation_fn(self.input)
    if self.output > self.fire_threshold
      fire
    end
    self.output
  end

  # sigmoid function basically exagerates the value between 0 and 1
  def activation_fn(input_value)
    1 / (1 + Math.exp(-input_value))
  end

  def sum_connections
    incoming.inject(0) {|sum,c| sum + (c.source.output * c.weight)} if incoming.any?
  end

  def fire
    self.fired = true
    outgoing.each do |c|
      c.target.activate(self.output)
    end
  end

  def fired?
    self.fired
  end

  # convenience method so you can set the weight
  def connect(*targets)
    targets.flatten.each do |target|       
      connection = Connection.new(self, target, self.options[:force_weight])
      self.outgoing << connection
      # for now we only handle connections in one direction
      target.incoming << connection
    end
  end

  # convenience method so you can set a weight
  def connect_one(target, weight)
      connection = Connection.new(self, target, weight)
      self.outgoing << connection
      # for now we only handle connections in one direction
      target.incoming << connection
  end

  def connections
    outgoing + incoming
  end

  def to_s
    "Neuron #{id} (#{self.output})" + "#{" *" if self.fired?}" +
    "\n  " + outgoing.join("\n  ").to_s
  end

  def self.reset_counter
    @@count = 0
  end

  def self.count
    @@count || 0
  end
end
