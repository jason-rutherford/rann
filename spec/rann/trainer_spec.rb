require 'spec_helper'

describe Rann::Trainer do
  describe '#initialize' do
    let(:network) { Rann::Network.new }
    let(:data)    { Rann::Trainer::DATA[:or_gate] }
    let(:trainer) { described_class.new(network, data) }

    it 'takes a network and data' do
      expect(trainer.network).to be_an_instance_of Rann::Network
      expect(trainer.data.nil?).to be_falsey
    end
  end

  describe '#train and #test' do
    let(:network) { Rann::Network.new(size: [2, 1], force_weight: 0.4) }
    let(:data)    { Rann::Trainer::DATA[:or_gate] }
    let(:trainer) { described_class.new(network, data) }

    it 'trains the network for logic OR gate' do
      trainer.train(epochs: 1000, log_frequency: 100)

      # 1000 epochs keeping it simple
      expect(trainer.test([0, 0]).first.round).to eq 0
      expect(trainer.test([0, 1]).first.round).to eq 1
      expect(trainer.test([1, 0]).first.round).to eq 1
      expect(trainer.test([1, 1]).first.round).to eq 1

      # 1000 epochs with precision
      expect(trainer.test([0, 0])).to eq [0.31908047362016845]
      expect(trainer.test([0, 1])).to eq [0.8767053317571771]
      expect(trainer.test([1, 0])).to eq [0.8671153044916092]
      expect(trainer.test([1, 1])).to eq [0.9900016321037731]
    end
  end
end
