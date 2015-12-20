# This is a benchmark of an experiment.  
# 
# CONCLUSION
# I've realized that this cache approach only performs well
# so long as the CACHE_SIZE is very small, like just 10. It was
# 2x faster but I just don't see that being practical. I guess this mean
# that the activation_fn is fast enough.
#
# Run it like this:
#  $ ruby -r ./app.rb spec/benchmarks/activation_fn_cache.rb

require 'benchmark/ips'

CACHE_SIZE = 1 # hash key digits, ie. 1 = 0-9 and 4 = 0000-9999

Benchmark.ips() do |x|
  #
  # Base. No cache.
  #
  @n = Neuron.new()
  x.report('base') do
   @n.activate(rand().round(CACHE_SIZE))
  end

  #
  # Try caching using instance variable
  #
  class Neuron
    def activation_fn_cache(input_value)
      #@activation_fn_cache = {} unless @activation_fn_cache
      @activation_fn_cache[input_value] || @activation_fn_cache[input_value] = (1 / (1 + Math.exp(-input_value)))
    end
  end
  @n = Neuron.new()
  x.report('instance cache') do
    @n.activation_fn_cache(rand().round(CACHE_SIZE))
  end

  #
  # Try caching using class variable
  #
  class Neuron
    @@activation_fn_cache = {}
    def activation_fn_class_cache(input_value)
      if @@activation_fn_cache[input_value]
        @@activation_fn_cache[input_value] 
      else 
        @@activation_fn_cache[input_value] = (1 / (1 + Math.exp(-input_value)))
      end
    end
  end
  @n = Neuron.new()
  x.report('class variable cache') do
    @n.activation_fn_class_cache(rand().round(CACHE_SIZE))
  end

  x.compare!

end