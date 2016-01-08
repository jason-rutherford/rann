# This class simply connects two objects together.  The connection has a source, target and weight.
class Connection
  attr_accessor :source, :target, :weight

  def initialize(source, target, weight = nil)
    @source = source
    @target = target
    @weight = weight || default_weight
  end

  def default_weight
    rand(-0.5..0.5)
  end

  def to_s
    " connection to Neuron #{target.id} x #{weight.round(4)}"
  end
end
