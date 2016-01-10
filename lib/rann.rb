require 'rann/version'
require 'rann/connection'
require 'rann/neuron'
require 'rann/layer'
require 'rann/network'
require 'rann/trainer'

module Rann


  @reloading ||= false

  def self.reload!
    @reloading = true
    no_reload = ['spec/', 'tmp/']
    ruby_files = Dir['**/*.rb']
    ruby_files.reject { |f| f =~ /#{no_reload.join('|')}/ }.each do |file|
      load file
    end
    @reloading = false
    true
  end

end
