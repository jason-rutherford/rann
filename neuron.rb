require './connection.rb'

class Neuron
  
  attr_accessor :id, :options, :input, :output, :weight, :outgoing, :incoming, :is_bias, :delta, :error, :learning_rate
  @@count = 0
  @@report_with = nil

  def initialize(options={})
    self.options = {}
    self.input  = options[:input] || 0
    self.output = options[:output] || 0
    self.is_bias = options[:is_bias] && self.output = 1 || false
    self.id = @@count += 1

    # connections
    self.incoming = []
    self.outgoing = []

    # train
    self.delta = nil
    self.error = nil
    self.learning_rate = 0.3

    self.options.merge! options
  end

  def is_bias?
    self.is_bias
  end

  def activate(value=nil)
    self.input = value || sum_connections
    if self.is_bias
      self.output = 1
    else
      self.output = activation_fn(self.input)
    end
    self.output
  end

  # sigmoid function basically exagerates the value between 0 and 1
  def activation_fn(input_value)
    1 / (1 + Math.exp(-input_value))
  end

  def sum_connections
    incoming.inject(0) {|sum,c| sum + (c.source.output * c.weight)}
  end

  #
  # Train
  #

  def train(target_output=nil)
    inputDerivative = activation_prime(self.input)
    # if is_output or target_output not nil
    if self.outgoing.empty?
      self.error = target_output - self.output
      self.delta = -self.error * inputDerivative
    else
      self.delta = outgoing.inject(0) { |sum, c| sum + (inputDerivative * c.weight * c.target.delta) }
    end

    # update weights
    outgoing.each do |connection|
      gradient = self.output * connection.target.delta
      connection.weight -= gradient * self.learning_rate
    end

  end

   # prime
  def activation_prime(x)
    val = 1 / (1 + Math.exp(-x))
    val * (1 - val)
  end

  #
  # End Train
  #

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

  # in case we want to see normal inspect, because we are going to override it below
  (alias_method :inspect_normal, :inspect) unless $reloading

  def inspect
    to_s
  end

  def to_s
    s = "#{"Bias " if self.is_bias}Neuron #{id} (IN: #{self.input || '__'} => OUT: #{self.output || '__'})"
    s += report_connections if @@report_with == :connections
    s
  end

  def report_connections
    "\n  " + outgoing.join("\n  ").to_s
  end

  # type can be nil for just neuron IO, or :connections to include outgoing connections
  def self.report_with(type=nil)
    @@report_with = type.to_sym
  end

  def self.reset_counter
    @@count = 0
  end

  def self.count
    @@count || 0
  end
end
