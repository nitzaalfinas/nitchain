# nitchain (early stage development)
NitChain is a blockchain project using Ruby. NitChain uses the consensus "Proof of Work" and this project is creating for research purposes.

## Install
* `bundle install`

## Run
`bundle exec rackup` or if you want to run in specific port, just run `bundle exec rackup -p 9090`

## Test
`rspec spec/main_spec.rb`

## Todo
* Sync
    * checking transaction
    * checking miner node (perlu atau tidak?)
    * checking reward
    * outputs address + including miner reward
    * time
        * prev block dan incoming block tidak boleh kurang dari 5 menit


## Flowcharts
Reading the code might be very difficult. But by reading the flowchart it is easier to understand.
### Create address
### Transfer
https://docs.google.com/drawings/d/1Q7IyBFYjyLAcXWH6LIovDMA_A8Ez8ksjOx8-LOZhUs8/edit?usp=sharing
### Pool
https://docs.google.com/drawings/d/1tDncmAuL5aoGakDyqX0C_pwbzrORy5aAhG5Qm5ZCIxw/edit?usp=sharing
### Mine
https://docs.google.com/drawings/d/10BSFAL-9VMh07_9qAVxPb5L8VDsL7HVUg9b1FVPDQ5E/edit?usp=sharing
