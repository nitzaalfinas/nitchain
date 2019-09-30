# nitchain (early stage development)
NitChain is a blockchain project using Ruby. NitChain uses the consensus "Proof of Stake" and this project is creating for research purposes.

## Install
* `bundle install`

## Command
```bash
ruby nitchain.rb --command wallet_create
ruby nitchain.rb --command wallet_transfer --data '{"block":3,"from":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","to":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","amount":100,"fee":5,"data":{},"time":1568933789}'
ruby nitchain.rb --command server_listen
ruby nitchain.rb --command sync --data '{"timesleep": 10}'
ruby nitchain.rb --command get_block --data 1
ruby nitchain.rb --command mine
```

## Test
```bash
ruby mytest/controller/test_block.rb
ruby mytest/controller/test_blockchain.rb
ruby mytest/controller/test_merkle.rb
ruby mytest/controller/test_pool.rb
ruby mytest/controller/test_transaction.rb
ruby mytest/controller/test_wallet.rb
```



## Flowcharts
Reading the code might be very difficult. But by reading the flowchart it is easier to understand.
### Create address
### Transfer
https://docs.google.com/drawings/d/1Q7IyBFYjyLAcXWH6LIovDMA_A8Ez8ksjOx8-LOZhUs8/edit?usp=sharing
### Pool
https://docs.google.com/drawings/d/1tDncmAuL5aoGakDyqX0C_pwbzrORy5aAhG5Qm5ZCIxw/edit?usp=sharing
### Mine
https://docs.google.com/drawings/d/10BSFAL-9VMh07_9qAVxPb5L8VDsL7HVUg9b1FVPDQ5E/edit?usp=sharing
