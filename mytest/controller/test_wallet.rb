require 'openssl'
require 'json'
require "test/unit"

ENV = "test"

require_relative "setup_test"

require_relative '../../controller/blockchain'
require_relative '../../controller/pool'
require_relative '../../controller/wallet'
require_relative '../../controller/transaction'

class TestWallet < Test::Unit::TestCase

    test "def create" do

        wallet_address = Wallet.create

        new_key_full_path = KEYSTORE_PATH + "/" + wallet_address

        ada = File.exist?(new_key_full_path)

        assert_equal(true, ada)

        # delete file after test
        File.delete(new_key_full_path) if File.exist?(new_key_full_path)

    end

    # sekarang adalah block nomor 2
    # test akan kita buat pada block nomor 3
    test "def balance" do

        # hapus semua yang ada pada blockchains
        SetupTest.destroy_blockchain_collections

        # hapus semua yang ada pada pools
        SetupTest.destroy_pool_collections

        # masukkan data block 1 dan 2
        SetupTest.seed_blockchains_collections

        assert_equal(95, Wallet.balance("Nxf154127e23cde0c8ecbaa8b943aff970c60c590f")[:data][:balance] )

        assert_equal(1000000005, Wallet.balance("Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096")[:data][:balance] )
    end

    # sekarang adalah block nomor 2
    # test akan kita buat pada block nomor 3
    test "def transfer" do

        # hapus semua yang ada pada blockchains
        SetupTest.destroy_blockchain_collections

        # hapus semua yang ada pada pools
        SetupTest.destroy_pool_collections

        # masukkan data block 1 dan 2
        SetupTest.seed_blockchains_collections

        data = '{"block":3,"from":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","to":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","amount":100,"fee":5,"data":{},"time":1568933789}'

        Wallet.transfer(data)

        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        assert_equal(3, mongoclient[:poolouts].find().to_a.count )

        assert_equal(1, mongoclient[:pools].find().to_a.count )
    end

end
