
class Connection
  attr_accessor :source, :target, :weight

  def initialize(source, target, weight = default_weight)
    self.source = source
    self.target = target
    self.weight = weight
  end

  def default_weight
    rand(-0.5..0.5)
  end

  def weight_by_factor(f)
    self.weight *= f
  end

  def to_s
    "  #{weight} x Neuron #{target.id}"
  end
end