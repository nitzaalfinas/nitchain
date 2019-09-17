require "test/unit"

require 'openssl'
require 'json'
require 'base64'
require 'mongo'
require 'redis'

ENV = "test"

require_relative '../../controller/block'
require_relative '../../controller/merkle'
require_relative '../../controller/transaction'
require_relative '../../controller/wallet'

class TestBlock < Test::Unit::TestCase


    def block_data
        data = {
            "hash":"00075cbbfcbdbb00425c48a61fe47e235ee65fd49e98313c558393067f79b288",
            "data":{
                "num":2,
                "prevhash":"000069e73b3b34e03031693d26e116713e2daf45e6150f24fd3977b758bc7bba",
                "tcount":1,
                "tamount":1000000100,
                "diff":3,
                "mroot":"ec0dbe032e88fa0f64b103453419d62d29e4ecbef27d7e983764df51bf5ad3ee",
                "miner":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                "reward":50,
                "txs":[
                    "4e90136b21c89e24bc9fe65eaa2dfe071e38a719201ef88f49d714609c4d949f"
                ],
                "txds":[
                    {
                        "hash":"4e90136b21c89e24bc9fe65eaa2dfe071e38a719201ef88f49d714609c4d949f",
                        "from":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "to":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign":"TeOANnD6AuZHpT+R35OZxbE1LR7/vVkjwM3kmU8ezefOGqFkRgwJofSXtwYx\nSwToCJmgRtm/qwcIrU0Rqoln3yxG4L2WXG/Kxszdp8zdRkHRydrA5rtbo0m8\nYPtOaFGCXcg7AtsxE2VclnGPhyIAow0kmOw/3ola/ZpdOClS6mw7P0eTSAcQ\n/gqV/R+p7Ceq7cYCBVohBjUVWIYar+iAGNeYqmTJSftc9EuK8fD9Odc4prHW\nLPqoVulwdkZDmrYNpHgT/27xQNZE53la+AeEIq1WZuCgENk1G0rV7qSgqT3Q\nvE1Vg3ujY0qRICfFIS7y1Z6/ZYB9Ba97i3LCguvUDQ==\n",
                        "tx":{
                            "input":{
                                "from":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                                "balance":1000000050,
                                "to":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                "amount":45,
                                "fee":5,
                                "data":{}
                            },
                            "outputs":[
                                {"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":1000000000},
                                {"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":45},
                                {"address":"miner","balance":5}
                            ],
                            "time":1568688154
                        }
                    }
                ],
                "outputs":[
                    {"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":1000000055},
                    {"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":45}
                ],
                "time":1567760775,
                "nonce":20123
            }
        }

        return data
    end

    test "valid genesis" do
        block = '{"hash":"000e6c46e0d566582fd5e060735b65519d2344a911e078f43162594264317386","data":{"num":1,"prevhash":"","tcount":1,"tamount":1000000050,"diff":3,"mroot":"126bc123f6d1892fae58677a5b13c15339ad06b08bff242e09e47157b877c288","miner":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","reward":50,"txs":["f57666994b70f36b783a79e3d8c0887bd9e63d946f3eb37efe4d0ca01cb20495"],"txds":[{"hash":"f57666994b70f36b783a79e3d8c0887bd9e63d946f3eb37efe4d0ca01cb20495","pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n","sign":"ACYxzKBsoM/JeyJRfLCZjfJ4WptoH/Ns1CFGf8q/2EiMvWADZtG+nJBOrLhQ\nLf7QyqISIg+VGW2yoO9444TAY2OAzJoEAaWaRifGDMY6Nnf+96vzsoOR+CLa\nrZDb2Q8vkbzVbr2UGbveSlwy+tZJ+DaTI6QmGuLBYwOyOMkCU2YOBmZtIXF1\nkHQlKgL3HSJO3BuJ5HYEaf2GPLBQYtuCFnT+68ys6/w0tG/Nth5r1yN4A90e\n8BYOux5nNhQyUPMukPHIU2td2wIQWcmCksS4+zf9mPbfhXh6gv+OFPJ9ZwND\nZ5VqAJLzDReJzhhgVBCvEzfpnHiGnRaAJEQ4TX0rFA==\n","tx":{"input":{"balance":1000000000,"from":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","to":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","amount":1000000000,"fee":0,"data":{}},"outputs":[{"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":0},{"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":1000000000},{"address":"miner","balance":0}],"time":1567676889}}],"outputs":[{"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":0},{"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":1000000050}],"time":1567743389,"nonce":5202}}'

        assert_equal(true, Block.validation(block)[:success])
    end

    test "valid block" do

        block = block_data.to_json

        puts Block.validation(block)

        # block yang diberikan adalah valid
        assert_equal(true, Block.validation(block)[:success])

    end

    test "data[num] invalid" do

        block = block_data

        block[:data][:num] = 5

        data = block.to_json

        assert_equal(false, Block.validation(data)[:success])

        # message must be invalid hash
        assert_equal("hashing(data) != hash", Block.validation(data)[:msg])

    end

    test "data[tcount] invalid" do

        block_obj = block_data
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
        block = block_data

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
        block = block_data

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
        block = block_data

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
