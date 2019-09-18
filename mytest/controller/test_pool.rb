require "test/unit"

require 'openssl'
require 'json'
require 'base64'
require 'mongo'
require 'redis'

ENV = "test"

require_relative "setup_test"

require_relative '../../controller/block'
require_relative '../../controller/merkle'
require_relative '../../controller/transaction'
require_relative '../../controller/wallet'
require_relative '../../controller/pool'

class TestPool < Test::Unit::TestCase

    def transaction_data
        data = {
            "hash": "4baf6c21c4611822971ee5c7354f3979cdb4c13b1a8972fefd04b4e0aa839730",
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
        return data
    end

    test "def self.add berhasil karena data belum ada" do
        SetupTest.destroy_pool_collections

        trxobj = JSON.parse(transaction_data.to_json)

        # masukkan data kedalam database pools
        Pool.add(trxobj.to_json)

        # cek apakah data masuk
        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
        jumlah_data = mongoclient[:pools].find({hash: trxobj["hash"]}).to_a.count

        assert_equal(1, jumlah_data)

    end

    # test disini memasukkan data 2x, tetapi hasil akhir tetap harus 1
    test "def self.add gagal karena data belum ada" do
        SetupTest.destroy_pool_collections

        trxobj = JSON.parse(transaction_data.to_json)

        # masukkan data kedalam database pools
        Pool.add(trxobj.to_json)

        # masukkan data kedalam database pools
        Pool.add(trxobj.to_json)

        # cek apakah data masuk
        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
        jumlah_data = mongoclient[:pools].find({hash: trxobj["hash"]}).to_a.count

        assert_equal(1, jumlah_data)

    end
end
