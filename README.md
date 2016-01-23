# NeuralNetwork

This is a WIP. This project demonstrates the basics of a neural network.  It features a network, layers, neurons and connections.

## Installation:

This is a ruby gem but unpublished from rubygems.org at the moment.

```sh 
git clone https://github.com/jason-rutherford/rann.git
```

Then in your project Gemfile:
```ruby
gem 'rann', path: 'YOUR_PATH_TO_RANN'
```

## Example Usage:
```ruby
require 'rann'

net = Rann::Network.new(size: [2, 1])
trainer = Rann::Trainer.new(net, Rann::Trainer::DATA[:or_gate])
trainer.train({ epochs: 10000 })

puts "Training Data Set: OR Gate"
puts Rann::Trainer::DATA[:or_gate]

puts "Testing Network:"
Rann::Trainer::DATA[:or_gate].each do |sample|
  output = net.activate(sample[:input]).first.round
  puts "in: #{sample[:input]} out: #{output}"
end
```

### Visualize the network

This can be useful while developing.

```ruby
network = Rann::Network.new({size: [1,2,1]})
network.to_s
```
will print out

```text
Network
 Input Layer 70272740914000
 Neuron 1 (IN: 0 => OUT: 0)
  Bias Neuron 5 (IN: 0 => OUT: 1)

 Hidden Layer 70272740913620
 Neuron 2 (IN: 0 => OUT: 0)
  Neuron 3 (IN: 0 => OUT: 0)
  Bias Neuron 6 (IN: 0 => OUT: 1)

 Output Layer 70272740913040
 Neuron 4 (IN: 0 => OUT: 0)
 ```
 
### Providing Network Input

You send input through your network be sending date through the activate method. When you activate the network it takes your inputs and passes it to the input layer, hidden layer and returns the output layer.

```ruby
network = Network.new({size: [1,2,1]})
network.activate([1])
```
activate() returns an array of outputs which can be thought of as the output layer neuron output values.  The last line above returns:

```
[
  [0] 0.6626302265192633
]
```

### Network Output

The `activate()` method will return the network output.  Alternatively, you can get the current output layer via the `output()` method.

```ruby
network.output
```

Just like `activate()`, this returns an array of output layer neuron output values.

```
[
  [0] 0.6626302265192633
]
```

# Running the tests

You can run the full test suite with:
```
$ rspec
```
or for specific files 
```
$ rspec spec/some-file.rb spec/some-other-file.rb
```

### Automatically run your tests

Using [guard](https://github.com/guard/guard) you can automatically run individual test files as you make changes.  Just run `guard` from the command-line and it will monitor your .rb files for changes and run tests that match in filename.  If you don't have guard install it with `gem install guard`.

# Misc

### Reloading Changes in irb
To reload any changes you make while in irb, you can simply call `reload!`.  This method is in `app.rb` and it searches the project path for ruby files, but it will filter some out, like any in your spec directory.

# TODO

- Lots of things
- More tests
- Activiation expansion. Support other activation functions? Expand activation thresholds?
- Backpropogation and Training

# Acknowledgements

 - I know. Ruby might not be the best language for a fast neural network.
 - Thanks to my local [dev-coop](https://github.com/dev-coop) for meetups
 - Special thanks to Levi Thomason ([levithomason](https://github.com/levithomason)) for teaching and driving inspiration
