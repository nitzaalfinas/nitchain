require 'openssl'
require 'json'
require "test/unit"
require 'awesome_print'

ENV = "test"

require_relative "setup_test"

require_relative '../../controller/mine'

class TestMine < Test::Unit::TestCase

    test "def mine" do
        SetupTest.destroy_blockchain_collections
        SetupTest.seed_blockchains_collections

        SetupTest.destroy_pool_collections
        SetupTest.seed_pool_collections

        puts Mine.mine
    end

end
