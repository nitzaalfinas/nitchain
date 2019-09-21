require 'openssl'
require 'json'
require "test/unit"
require 'awesome_print'

ENV = "test"

require_relative "setup_test"

require_relative '../../controller/blockchain'
require_relative '../../controller/merkle'
require_relative '../../controller/mine'

class TestMine < Test::Unit::TestCase

    # sekarang blockchain height adalah #2
    # disini kita akan mencoba mining block nomor 3
    test "def mine" do

        # hapus semua data blockchains dan masukkan kembali
        SetupTest.destroy_blockchain_collections
        SetupTest.seed_blockchains_collections

        # hapus semua data pools dan masukkan
        SetupTest.destroy_pool_collections
        SetupTest.seed_pool_collections

        puts Mine.mine.to_yaml
    end

end
