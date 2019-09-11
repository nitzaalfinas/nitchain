require 'openssl'
require 'json'
require "test/unit"
require 'awesome_print'

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

        puts Transaction.create(datainput_json).to_json

    end

    test "def validation" do
        def data_start
            data_to_validate = {
                "hash":"f45a614f0725d9981182735af505af71e02bfa0c56958ba648dd9cee9b63eb5a",
                "pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
                "sign":"blDZiWejsa/B6EKWS4LBgXxsZi/LYFxJ0uQ+NvNKL1GhhT6BpxxEB7HyVTAd\n7EvRumkKofeHzQBwJdFLeNwGfpBjvTfi2S1lDOU0gSHZdFPOUDWyDfZl56f5\nHhJaSS0F1L/mEER1qUVwSqTVIFsUSEwDfcN6pnMsQO61QjYTKAAKngFevy3+\nQalEDh3xxSWd/47i11tn2Gr4plFKzAjPJNoUrOvzVrPXbRjFw3oUrKBqGO1T\nJCeQ0nhbjIU5DtMExdNnjXP2l7OPB56VziXRGNC0kMMp394WYIKKJV+6rz2i\nslA6O816o5Q3DYqmXJHTQ4mVqds8LEWxmVmNacTxsg==\n",
                "tx":{
                    "input":{
                        "balance":1000000050,
                        "from":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "to":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "amount":100,
                        "fee":5,
                        "data":{}
                    },
                    "outputs":[
                        {"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":999999945},
                        {"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":100}
                    ],
                    "time":1568218748
                }
            }
            return data_to_validate
        end

        # --- false "invalid format"---
        # hapus sign
        data = data_start
        data.delete(:sign)
        data_hash_key_string = JSON.parse(data.to_json)
        assert_equal(false, Transaction.validation(data_hash_key_string)[:success])
        # --- false ---

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
        assert_equal(true, Transaction.validation(data_hash_key_string)[:success])
        # --- true ---


    end

end
