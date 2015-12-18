
class Connection
  attr_accessor :source, :target, :weight

  def initialize(source, target, weight = nil)
    self.source = source
    self.target = target
    self.weight = weight || default_weight
  end

  def default_weight
    rand(-0.5..0.5)
  end

  def weight_by_factor(f)
    self.weight *= f
  end

  def to_s
    "  Neuron #{target.id} x #{weight.round(4)}"
  end
end