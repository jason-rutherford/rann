require 'rann'
network = Rann::Network.new({ size: [2,1], force_weight: 0.4 })
trainer = Rann::Trainer.new(network, Rann::DATA[:or_gate])
trainer.train({ epochs: 10001, log_frequency: 1000 })

