require 'openssl'
require 'json'
require "test/unit"
require 'awesome_print'

ENV = "test"

require_relative "setup_test"

require_relative '../../controller/wallet'
require_relative '../../controller/transaction'

class TestTransaction < Test::Unit::TestCase

    test "def validation" do
        def data_start
            data_to_validate = {
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
            return data_to_validate
        end

        # ------------
        # karena transaksi ini harus diletakkan pada block nomor 3, maka kita harus hapus semua data dan berikan seed untuk populasi database jadi block 1 dan 2
        SetupTest.destroy_blockchain_collections
        SetupTest.seed_blockchains_collections
        # ------------

        # --- false "invalid format"---
        # hapus sign
        data = data_start
        data.delete(:sign)
        data_hash_key_string = JSON.parse(data.to_json)
        assert_equal(false, Transaction.validation(data_hash_key_string)[:success])
        # --- false ---

        # --- false "invalid comparison hash and tx"---
        # ganti data input balance
        data = data_start
        data[:tx][:input][:balance] = 10
        data_hash_key_string = JSON.parse(data.to_json)
        assert_equal(false, Transaction.validation(data_hash_key_string)[:success])
        # --- false ---

        # --- false "invalid address from or to"---
        # hilangkan from
        data = data_start
        data[:tx][:input][:from] = ""
        data_hash_key_string = JSON.parse(data.to_json)
        assert_equal(false, Transaction.validation(data_hash_key_string)[:success])
        # --- false ---

        # --- false "invalid comparison address from and public key"---
        # ganti saja address from
        data = data_start
        data[:tx][:input][:from] = "Nx"
        data_hash_key_string = JSON.parse(data.to_json)
        assert_equal(false, Transaction.validation(data_hash_key_string)[:success])
        # --- false ---

        # --- false "invalid amount"---
        # ganti sedikit balance
        data = data_start
        data[:tx][:input][:balance] = 9
        data_hash_key_string = JSON.parse(data.to_json)
        assert_equal(false, Transaction.validation(data_hash_key_string)[:success])
        # --- false ---

        # --- true ---
        data = data_start
        data_hash_key_string = JSON.parse(data.to_json)
        puts 'Transaction.validation(data_hash_key_string) -----'
        puts Transaction.validation(data_hash_key_string)
        #assert_equal(true, Transaction.validation(data_hash_key_string)[:success])
        # --- true ---


    end

end
