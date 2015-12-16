# add this file's path to the $LOAD_PATH
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'network.rb'

def reload!
  no_reload = ['spec/', 'tmp/']
  ruby_files = Dir['**/*.rb']
  ruby_files.reject { |f| f =~ /#{no_reload.join('|')}/}.each do |file|
    load file
  end
  true
end