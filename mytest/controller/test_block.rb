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

class TestBlock < Test::Unit::TestCase


    test "valid genesis" do
        block = '{"hash":"00006f331df1d08034b22489829c784d1c45be2c37813f8ed37a433de9a09566","data":{"num":1,"prevhash":"","tcount":1,"tamount":1000000050,"diff":3,"mroot":"0730acf829510535b17a197a7e1f749157b19e59fbee68df6741991a03e6f3c9","miner":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","reward":50,"tfee":0,"txs":["a3de365c86430d86f0ff2a0d126024026c0669dabf53957f99b0e0a7046276ee"],"txds":[{"hash":"a3de365c86430d86f0ff2a0d126024026c0669dabf53957f99b0e0a7046276ee","pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n","sign":"I+WWwxBoJrwDdCiX2LYevo1xciUmUCXlz2bYz1yzj4j69ftApMjakl/PSY1L\nPMIqyUb3qnUuwOn+ALb+7e3ip+UEWq3vtwGV9nn1lCaEzfdEaaAqAovKHZwz\nXSTW1JBp8r5KzWGuezMmgJCjZHM1yvO/2NOxWe3I2l1BZwluoUx1PNkMt5Nh\nWdzjGx2oL5kffBMNB+Zzn2N/ejYx00dzcanJ6x9UPFq6Wh9xp87vEU51IvyH\n2aOeOaa7KSKe24TbuITVqteBPh+vvOz2CPoQEYkZD5lVkNhgvACG5B0fz524\n9KXumni5aOUB9ZOH2zMBhF2AUb3LHPdodVxdrRtmmA==\n","tx":{"block":1,"from":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","to":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","amount":1000000000,"fee":0,"data":{},"time":1567676889}}],"outputs":[{"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":0},{"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":1000000050}],"time":1569022753,"nonce":386}}'

        assert_equal(true, Block.validation(block)[:success])
    end

    test "valid block number 3" do
        block = SetupTest.block_three

        assert_equal(true, Block.validation(block.to_json)[:success])
    end

    test "valid block" do

        SetupTest.destroy_blockchain_collections
        SetupTest.seed_blockchains_collections

        block = SetupTest.block_three.to_json

        # block yang diberikan adalah valid
        assert_equal(true, Block.validation(block)[:success])

    end

    test "data[num] invalid" do

        block = SetupTest.block_three

        block[:data][:num] = 5

        data = block.to_json

        assert_equal(false, Block.validation(data)[:success])

        # message must be invalid hash
        assert_equal("hashing(data) != hash", Block.validation(data)[:msg])

    end

    test "data[tcount] invalid" do

        block_obj = SetupTest.block_three
        block_obj[:data][:tcount] = 100

        block_json = block_obj.to_json

        assert_equal(false, Block.validation(block_json)[:success])

        assert_equal(false, Block.checking_transaction_count(JSON.parse(block_json))[:success])
        assert_equal("transaction count is not match (1)", Block.checking_transaction_count(JSON.parse(block_json))[:msg])

        # --- transaction data is not match (txds)
        # right data
        block_obj[:data][:tcount] = 1
        # wrong data (2 datas)
        block_obj[:data][:txds] = [
            {
                "hash": "e358ac153c05ddf8842da698e151d1147f895258862f4485cd3644a7378e2027",
                "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
                "sign": "MIuDG8b+T32nFKYBs3HY7UXokuwIQ3PfMduxx5oQATaaxTVnJVP7RXe6Xkhr\nR+SWjQ9yDWxoE9lmaFROHCR6VjfFSM+LtQ9uktRyhCuRLVIGEII4f8RWSgMg\nTVssCCjim8sc8JSHp7V88XOmnwOduCdQQDGvqRDvdHvOJ/Bk4kgycInByEjY\nQQI9vqtRMige+6qbP9eOteRG7rl3/D9v85fCy33bTIANVdibwPQtNd/pwOYE\nnaduWMRNkicdLooUfJsNt4yPSi12MX/mxUpmft3aMw7EB48ePJ9OoJHOcIT+\nLb/Ja6Y9xm1QuOCTxlOscW4C+jfMEyGHQij67DfA3w==\n",
                "tx": {
                    "input": {
                        "balance": 999900100,
                        "from": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "to": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "amount": 200000,
                        "fee": 5,
                        "data": {}
                    },
                    "outputs": [
                        { "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f", "balance": 999700100 },
                        { "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096", "balance": 300000 }
                    ],
                    time: 1567760639
                }
            },
            {
                "hash": "e358ac153c05ddf8842da698e151d1147f895258862f4485cd3644a7378e2027",
                "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
                "sign": "MIuDG8b+T32nFKYBs3HY7UXokuwIQ3PfMduxx5oQATaaxTVnJVP7RXe6Xkhr\nR+SWjQ9yDWxoE9lmaFROHCR6VjfFSM+LtQ9uktRyhCuRLVIGEII4f8RWSgMg\nTVssCCjim8sc8JSHp7V88XOmnwOduCdQQDGvqRDvdHvOJ/Bk4kgycInByEjY\nQQI9vqtRMige+6qbP9eOteRG7rl3/D9v85fCy33bTIANVdibwPQtNd/pwOYE\nnaduWMRNkicdLooUfJsNt4yPSi12MX/mxUpmft3aMw7EB48ePJ9OoJHOcIT+\nLb/Ja6Y9xm1QuOCTxlOscW4C+jfMEyGHQij67DfA3w==\n",
                "tx": {
                    "input": {
                        "balance": 999900100,
                        "from": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "to": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "amount": 200000,
                        "fee": 5,
                        "data": {}
                    },
                    "outputs": [
                        { "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f", "balance": 999700100 },
                        { "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096", "balance": 300000 }
                    ],
                    time: 1567760639
                }
            }
        ]
        assert_equal(false, Block.checking_transaction_count(JSON.parse(block_obj.to_json))[:success])
        assert_equal("transaction count is not match (2)", Block.checking_transaction_count(JSON.parse(block_obj.to_json))[:msg])

    end

    test "def checking_total_amount" do
        block = SetupTest.block_three

        # --- hasil benar ---
        data_json = block.to_json
        data_with_hashkey_in_string = JSON.parse(data_json)
        result_a = Block.checking_total_amount(data_with_hashkey_in_string)
        assert_equal(true, result_a[:success])
        # --- hasil benar ---

        # --- hasil salah ---
        # ganti data total_amount
        block[:data][:tamount] = 88888
        data_json = block.to_json
        data_with_hashkey_in_string = JSON.parse(data_json)
        result_b = Block.checking_total_amount(data_with_hashkey_in_string)
        assert_equal(false, result_b[:success] )
        # --- hasil salah ---

    end

    test "def checking_difficulty" do
        block = SetupTest.block_three

        # --- hasil benar ---
        data_json = block.to_json
        data_with_hashkey_in_string = JSON.parse(data_json)
        result_a = Block.checking_difficulty(data_with_hashkey_in_string)
        assert_equal(true, result_a[:success])
        # --- hasil benar ---

        # --- hasil salah ---
        # ganti data difficulty
        block[:data][:diff] = 4
        data_json = block.to_json
        data_with_hashkey_in_string = JSON.parse(data_json)
        result_b = Block.checking_difficulty(data_with_hashkey_in_string)
        assert_equal(false, result_b[:success] )
        # --- hasil salah ---

    end

    test "def checking_merkle" do
        block = SetupTest.block_three

        # --- hasil benar ---
        data_json = block.to_json
        data_with_hashkey_in_string = JSON.parse(data_json)
        result_a = Block.checking_merkle(data_with_hashkey_in_string)
        assert_equal(true, result_a[:success])
        # --- hasil benar ---

        # --- hasil salah ---
        # ganti data merkle root
        block[:data][:mroot] = "asal saja"
        data_json = block.to_json
        data_with_hashkey_in_string = JSON.parse(data_json)
        result_b = Block.checking_merkle(data_with_hashkey_in_string)
        assert_equal(false, result_b[:success] )
        # --- hasil salah ---

    end
end
