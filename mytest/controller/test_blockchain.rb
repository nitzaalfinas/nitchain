require "test/unit"

require 'openssl'
require 'json'
require 'base64'
require 'mongo'
require 'redis'

ENV = "test"

require_relative "setup_test"

require_relative '../../controller/block'
require_relative '../../controller/blockchain'
require_relative '../../controller/merkle'
require_relative '../../controller/transaction'
require_relative '../../controller/wallet'

class TestBlockchain < Test::Unit::TestCase

    test "def  add_incoming_block" do

        SetupTest.destroy_blockchain_collections
        SetupTest.seed_blockchains_collections

        assert_equal(true, Blockchain.add_incoming_block(SetupTest.block_three.to_json)[:success])
    end

end
