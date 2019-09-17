require "test/unit"

require 'openssl'
require 'json'
require 'base64'
require 'mongo'
require 'redis'

ENV = "test"

require_relative '../../controller/block'
require_relative '../../controller/blockchain'
require_relative '../../controller/merkle'
require_relative '../../controller/transaction'
require_relative '../../controller/wallet'

class TestBlockchain < Test::Unit::TestCase

    # data yang akan ditambahkan adalah block nomor 3
    def incoming_block_data
        data = {
            "hash": "000746211fb44930c2a68d7f1b154c5557a61d1af62cd725aba37a55f0b57910",
            "data": {
                "num": 3,
                "prevhash": "0002aab859017d41b67d9c2b14acb3cc264fbbf5ff3bb71b6e1f92826c6a237b",
                "tcount": 1,
                "tamount": 1000000150,
                "diff": 3,
                "mroot": "ac8addc0665dfa7fc06c0b5a4daec06a2834be9d766623d85fff395d91e3119e",
                "miner": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                "reward": 50,
                "txs": [
                    "4baf6c21c4611822971ee5c7354f3979cdb4c13b1a8972fefd04b4e0aa839730"
                ],
                "txds": [
                    {
                        "hash": "4baf6c21c4611822971ee5c7354f3979cdb4c13b1a8972fefd04b4e0aa839730",
                        "from": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "to": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign": "dV+b+7gArDPoadFe1PZv3CjOCgyhBGNoBr6N8qFcLrZsDIMuR3z/qM1xKDiS\nbvOeeRgtKjeKpkg55nvoctCoilpTuccEV6BHSsQuQB6zDiUb601p/L0JfJhK\nWj7eUQejYj+nnPAZNzG39o362pjWmqscgT15Az1avVji0Fz4AL+kAuRt5h4d\nIejBO61CtcjCO72VFMJqmmTYvpYUSojOJ5oN0WJ/r5mdbMVmpiD4ORh2z9BA\nONgy1tlVH4r/fnDfKmfoTW7rkYdM/sqVSyHmsNK+NpX5OsfqcMz3B9TLMyjC\niYdhwJMKZ/2jkEaIa/VUZSCBj0w7qEe3yZfF/kKyoA==\n",
                        "tx": {
                            "input": {
                                "from": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                                "balance": 1000000055,
                                "to": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                "amount": 95,
                                "fee": 5,
                                "data": {}
                            },
                            "outputs": [
                                {
                                    "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                                    "balance": 999999955
                                },
                                {
                                    "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                    "balance": 140
                                },
                                {
                                    "address": "miner",
                                    "balance": 5
                                }
                            ],
                            "time": 1568695754
                        }
                    }
                ],
                "outputs": [
                    {
                        "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "balance": 1000000010
                    },
                    {
                        "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "balance": 140
                    }
                ],
                "time": 1567760775,
                "nonce": 32724
            }
        }

        return data
    end

    test "def  add_incoming_block" do
        incomdata = incoming_block_data.to_json

        puts Blockchain.add_incoming_block(incomdata)

        assert_equal(true, Blockchain.add_incoming_block(incomdata)[:success])
    end

end
