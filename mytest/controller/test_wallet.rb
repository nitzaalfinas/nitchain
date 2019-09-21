require 'openssl'
require 'json'
require "test/unit"

ENV = "test"

require_relative '../../controller/wallet'
require_relative '../../controller/transaction'

class TestWallet < Test::Unit::TestCase

    # SEBAIKNYA INI DITEST MANUAL
    test "def balance" do

        puts Wallet.balance("Nxf154127e23cde0c8ecbaa8b943aff970c60c590f").to_yaml
    end

    test "def transfer" do
        data = '{"block":3,"from":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","to":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","amount":100,"fee":5,"data":{},"time":1568933789}'

        puts Wallet.transfer(data)
    end

end
