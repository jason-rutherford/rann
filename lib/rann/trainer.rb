module Rann
  # This class handles network training.  Pass it a network and training data and call train.
  class Trainer

    DATA = {
      or_gate: [
                 { input: [0, 0], output: [0] },
                 { input: [0, 1], output: [1] },
                 { input: [1, 0], output: [1] },
                 { input: [1, 1], output: [1] }
               ]
    }

    attr_accessor :network, :data
    def initialize(network, data)
      self.network = network
      self.data = data
    end

    def train(options)
      epochs = options[:epochs]
      log_frequency = options[:log_frequency].to_i

      epochs.to_i.times do |i|
        # puts "*" * 80
        self.data.each_with_index do |sample, idx|
          self.network.activate(sample[:input])
          self.network.train(sample[:output])
          if log_frequency && i % log_frequency == 0
            puts "epoch #{i} sample input:  #{sample[:input]} network output: #{self.network.activate(sample[:input])}"
          end
        end
      end
    end

    def test(input)
      network.activate(input)
    end
  end
end
