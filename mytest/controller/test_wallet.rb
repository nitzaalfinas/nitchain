require 'openssl'
require 'json'
require "test/unit"

ENV = "test"

require_relative '../../controller/wallet'
require_relative '../../controller/transaction'

class TestWallet < Test::Unit::TestCase

    # SEBAIKNYA INI DITEST MANUAL
    test "def balance" do

        puts Wallet.balance("Nxf154127e23cde0c8ecbaa8b943aff970c60c590f")
    end

    

end
