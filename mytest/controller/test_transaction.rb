require 'openssl'
require 'json'
require "test/unit"

ENV = "test"

require_relative '../../controller/wallet'
require_relative '../../controller/transaction'

class TestTransaction < Test::Unit::TestCase

    test "def create" do

        datainput = {
            from: "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
            to: "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
            amount: 100
        }

        # data harus berupa json
        datainput_json = datainput.to_json

        puts Transaction.create(datainput_json)

    end

end
