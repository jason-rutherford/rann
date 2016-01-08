require './connection.rb'
# This class handles the neurons.  You can connect them together and train them.
class Neuron
  attr_accessor :id, :options, :input, :output, :weight, :outgoing, :incoming, :bias, :delta, :error, :learning_rate
  @@count = 0
  @@report_with = nil

  def initialize(options = {})
    self.options       = {}
    self.input         = options[:input] || 0
    self.output        = options[:output] || 0
    self.bias          = options[:bias] && self.output = 1 || false
    self.id            = @@count += 1

    # connections
    self.incoming      = []
    self.outgoing      = []

    # train
    self.delta         = nil
    self.learning_rate = 0.3
    self.error         = 0

    self.options.merge! options
  end

  def bias?
    bias
  end

  def activate(value = nil)
    self.input = value || sum_connections
    if bias?
      self.output = 1
    else
      self.output = activation_fn(input)
    end
    output
  end

  # sigmoid function basically exagerates the value between 0 and 1
  def activation_fn(input_value)
    1 / (1 + Math.exp(-input_value))
  end

  def sum_connections
    incoming.inject(0) { |sum, c| sum + (c.source.output * c.weight) }
  end

  #
  # Train
  #

  def train(target_output = nil)
    calculate_delta(target_output) if !bias && !incoming.empty?
    update_connection_weights
  end

  def calculate_delta(target_output)
    if outgoing.empty?
      self.delta = output - target_output
    else
      self.delta = outgoing.inject(0) { |sum, c| sum + (c.weight * c.target.delta) }
    end
  end

  def update_connection_weights
    outgoing.each do |connection|
      gradient = output * connection.target.delta
      connection.weight -= gradient * learning_rate
    end
  end

  def error_fn
  end

  def set_error
  end

  def accumulate
    # the gradient
    connections.incoming
  end

  # prime
  def activation_prime(x)
    val = 1 / (1 + Math.exp(-x))
    val * (1 - val)
  end

  #
  # End Train
  #

  def connect(*targets)
    targets.flatten.each do |target|
      connection = Connection.new(self, target, options[:force_weight])
      outgoing << connection
      target.incoming << connection
    end
  end

  # convenience method so you can set a weight
  def connect_one(target, weight)
    connection = Connection.new(self, target, weight)
    outgoing << connection
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
    s = "#{'Bias ' if bias}Neuron #{id} (IN: #{input || '__'} => OUT: #{output || '__'})"
    s += report_connections if @@report_with == :connections
    s
  end

  def report_connections
    "\n  " + outgoing.join("\n  ").to_s
  end

  # type can be nil for just neuron IO, or :connections to include outgoing connections
  def self.report_with(type = nil)
    @@report_with = type.to_sym
  end

  def self.reset_counter
    @@count = 0
  end

  def self.count
    @@count || 0
  end
end
