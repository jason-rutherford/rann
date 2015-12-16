# NeuralNetwork

This is a WIP. This project demonstrates the basics of a neural network.  It features a network, layers, neurons and connections.

## Example Usage:

This is a ruby project.

```sh 
irb -r ./app.rb
```
Then in irb:
```ruby
network = Network.new({size: [1,2,1]})
```
The size array defines number of neurons in each layer. 
Input and output layers are first and last of array respectively.

### Visualize the network

```ruby
network = Network.new({size: [1,2,1]})
network.to_s
```
prints to $stdout

```text
Network
 Input Layer 70142336303140
  Neuron 1 ()
    0.0271683740583486 x Neuron 2
    -0.33475448030016197 x Neuron 3

 Hidden Layer 70142336294780
  Neuron 2 ()
    0.04857889234390422 x Neuron 4
  Neuron 3 ()
    -0.2474446077707908 x Neuron 4

 Output Layer 70142336294480
  Neuron 4 ()
  #<IO:0x007f96920ca5a0>
 ```
 
 Notice from the above that the network initializes neuron connections with random weights ie. 0.0271683740583486 x Neuron 2
 
 Layers can be of type Input, Hidden and Output.  The layer object_id is included in the to_s output.
 
### Network Input

You send input through your network by feeding it. When you feed the network it takes your input and passes it to the input layer, hidden layer and returns the output layer.

```ruby
network = Network.new({size: [1,2,1]})
network.feed(1)
```
feed() returns an array of outputs which can be thought of as the output layer neuron output values.  The last line above returns:

```
[
  [0] 0.6626302265192633
]
```

### Network Output

The `feed()` method will return the network output.  Alternatively, you can get the current output layer via the `output()` method.

```ruby
network.output
```

returns

```
[
  [0] 0.6626302265192633
]
```

# Misc

To reload any changes you make while in irb, you can simply call `load [filename]`.

# TODO

- Lots of things
- More tests
- Activiation expansion. Support other activation functions? Expand activation thresholds?
- Backpropogation and Training

# Acknowledgements

 - I know. Ruby might not be the best language for a fast neural network.
 - Thanks to my local [dev-coop](https://github.com/dev-coop) for meetups
 - Special thanks to Levi Thomason ([levithomason](https://github.com/levithomason)) for teaching and driving inspiration
