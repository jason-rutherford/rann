# add this file's path to the $LOAD_PATH
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'network.rb'
$reloading = $reloading || false

def reload!
  $reloading = true
  no_reload = ['spec/', 'tmp/']
  ruby_files = Dir['**/*.rb']
  ruby_files.reject { |f| f =~ /#{no_reload.join('|')}/ }.each do |file|
    load file
  end
  $reloading = false
  true
end
