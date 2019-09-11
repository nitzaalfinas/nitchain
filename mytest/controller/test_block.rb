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
            "hash": "0006aea0806ea0a4f8e30f6c65a3ba2b7bf995085f5e8db6bc8d23b101cfb5fc",
            "data": {
                "num": 3,
                "prevhash": "000caf794e47a613d9000a4dce1b37ab4894502c9fc218fc49019ab112708601",
                "tcount": 1,
                "tamount": 1000000150,
                "diff": 3,
                "mroot": "1d664bdd0c6e4946e56b3ce46d9f668e49f1a958f45f168af347c457d77022d9",
                "miner": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                "reward": 50,
                "txs": [ "e358ac153c05ddf8842da698e151d1147f895258862f4485cd3644a7378e2027" ],
                "txds": [
                    {
                        "hash": "e358ac153c05ddf8842da698e151d1147f895258862f4485cd3644a7378e2027",
                        "from": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "to": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign": "MIuDG8b+T32nFKYBs3HY7UXokuwIQ3PfMduxx5oQATaaxTVnJVP7RXe6Xkhr\nR+SWjQ9yDWxoE9lmaFROHCR6VjfFSM+LtQ9uktRyhCuRLVIGEII4f8RWSgMg\nTVssCCjim8sc8JSHp7V88XOmnwOduCdQQDGvqRDvdHvOJ/Bk4kgycInByEjY\nQQI9vqtRMige+6qbP9eOteRG7rl3/D9v85fCy33bTIANVdibwPQtNd/pwOYE\nnaduWMRNkicdLooUfJsNt4yPSi12MX/mxUpmft3aMw7EB48ePJ9OoJHOcIT+\nLb/Ja6Y9xm1QuOCTxlOscW4C+jfMEyGHQij67DfA3w==\n",
                        "tx": {
                            "input": {
                                "from": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                "balance": 999900100,
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
                ],
                "outputs": [
                    { "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f", "balance": 999700150 },
                    { "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096", "balance": 300000 }
                ],
                "time": 1567760775,
                "nonce": 7626
            }
        }

        return data
    end

    test "valid genesis" do
        block = '{"hash":"00084a9049395be1e5e7400d39b48bc854d410c80134932ff196c911b6b3872d","data":{"num":1,"prevhash":"","tcount":1,"tamount":1000000050,"diff":3,"mroot":"8519950eab1d0649f314f8c96da5737f2e9c19a8f6fe02e2ce351e207fee6b5c","miner":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","reward":50,"txs":["d9dec8b533cb0c3946969d8ede66709d65d289b5b6b0dd175fc1880a23f55dee"],"txds":[{"hash":"d9dec8b533cb0c3946969d8ede66709d65d289b5b6b0dd175fc1880a23f55dee","pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n","sign":"Llr3rs+NeUFor0o4ledioJ5hgKW60eXSR6J6OIeF1yEY1trzP7MxC8Pi+EUW\nG/6On5Zqru3BzJ/V20W5XTRt3StXydUrsUnSOkHgZk0b3SbEGeabjrgook/f\n7CZ6qvOo5E2PHcbda0BcnLqdt8hpAwd6sYF1bz7obb8IQlZm9m/Q8mw9PEM1\n+avDhff61Vyi60H6Uty8uTxtJVV9yMzViZvBVQnNkLQXzX4NBmXEqs6VjHNg\nBdlqz6JEVqLNs2ZBDurW1/y/vUY/myZ8YeW2fWA1W/3Y0yg5uvlGQEKuHcuW\n8nPTda52i9kl9q4C4t1CpPhC/d966Z9Lat+R0ucS4w==\n","tx":{"input":{"balance":1000000000,"from":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","to":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","amount":1000000000,"fee":0,"data":{}},"outputs":[{"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":0},{"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":1000000000}],"time":1567676889}}],"outputs":[{"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":1000000050}],"time":1567743389,"nonce":5600}}'

        assert_equal(true, Block.validation(block)[:success])
    end

    test "valid block" do

        block = block_data.to_json

        puts Block.validation(block).to_yaml

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
