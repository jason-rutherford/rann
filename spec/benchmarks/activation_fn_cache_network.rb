# This is a benchmark of an experiment.  
# 
# CONCLUSION
# Inconclusive.
#
# Run it like this:
#  $ ruby -r ./app.rb spec/benchmarks/activation_fn_cache_network.rb

require 'benchmark/ips'

CACHE_INPUT_SIZE = 1000 # digits, ie. 4 = 9999

Benchmark.ips() do |x|

  #
  # Try caching using class variable
  #
  class Neuron
    @@activation_fn_cache = {}
    def activation_fn(input_value)
    
      # Toggle Experiment here
      @@activation_fn_cache = {} if @@activation_fn_cache.size > CACHE_INPUT_SIZE * 10
      @@activation_fn_cache[input_value] || @@activation_fn_cache[input_value] = (1 / (1 + Math.exp(-input_value)))
    
      # Toggle Base here
      (1 / (1 + Math.exp(-input_value)))
    end
  end
  @n = Network.new(size: [10,20,1])
  x.report('instance cache') do
    @n.feed(10.times.map {rand(1000000)})
  end

  x.compare!

end