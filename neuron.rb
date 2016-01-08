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
    self.learning_rate = 0.3
    self.error = 0

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
    if (!self.is_bias && !self.incoming.empty?)
      # if is_output or target_output not nil
      if self.outgoing.empty?
        # this is derivative of error function, not simply difference in output
        self.delta = self.output - target_output
      else
        self.delta = outgoing.inject(0) { |sum, c| sum + (c.weight * c.target.delta) }
      end
    end

    # update weights
    outgoing.each do |connection|
      gradient = self.output * connection.target.delta
      connection.weight -= gradient * self.learning_rate
    end

  end

  def error_fn

  end

  def set_error

  end

  def accumulate
    gradient = self.connections.incoming
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
      connection = Connection.new(self, target, options[:force_weight])
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
    s = "#{"Bias " if is_bias}Neuron #{id} (IN: #{input || '__'} => OUT: #{output || '__'})"
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
