require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative "env"

class Block
    attr_accessor :hash, :data

    def initialize(hash, data)
        @hash = hash
        @data = data
    end


    def self.validation(block)

        block = JSON.parse(block)

        if Block.checking_data_structure(block)[:success] == true

            # puts"satu"

            if Block.checking_hash_and_data(block)[:success] === true

                # puts"dua"

                if Block.checking_transaction_count(block)[:success] == true

                    # puts"tiga"

                    if Block.checking_total_amount(block)[:success] == true

                        # puts"empat"

                        if Block.checking_difficulty(block)[:success] == true

                            # puts"lima"

                            if Block.checking_merkle(block)[:success] == true

                                # puts"enam"

                                if Block.checking_tx_datas(block)[:success] == true

                                    # puts"7"

                                    return {
                                        success: true
                                    }
                                else
                                    return Block.checking_tx_datas(block)
                                end
                            else
                                return Block.checking_merkle(block)
                            end
                        else
                            return Block.checking_difficulty(block)
                        end
                    else
                        return Block.checking_total_amount(block)
                    end
                else
                    return Block.checking_transaction_count(block)
                end
            else
                return Block.checking_hash_and_data(block)
            end
        else
            return Block.checking_data_structure(block)
        end
    end

    ##
    # == Keterangan
    # - apakah punya hash?
    # - apakah punya data[:num]?
    # - apakah punya data[:prevhash]?
    # - apakah punya data[:tcount]?
    # - apakah punya data[:tamount]?
    # - apakah punya data[:diff]?
    # - apakah punya data[:mroot]?
    # - apakah punya data[:miner]?
    # - apakah punya data[:reward]?
    # - apakah punya data[:txs]?
    # - apakah punya data[:txds]?
    # - apakah punya data[:outputs]?
    # - apakah punya data[:time]?
    # - apakah punya data[:nonce]?
    #
    # == Contoh data
    # Start data block nomor 2 -------------
    # {
    #     "hash" : "000caf794e47a613d9000a4dce1b37ab4894502c9fc218fc49019ab112708601",
    #     "data" : {
    #         "num" : 2,
    #         "prevhash" : "000762b951668aed0c00ab95819457242654864beb09e14922d5d1d99d541043",
    #         "tcount" : 1,
    #         "tamount" : 1000000100,
    #         "diff" : 3,
    #         "mroot" : "040463949dca9c116d4725f61675acf01ad07b63f51bcfe8ed89780f555ba844",
    #         "miner" : "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #         "reward" : 50,
    #         "txs" : [
    #             "9c81dff5bcdc7909b7e3f042280583e36ab8073e3146ae70046b6f338a6dbb7a"
    #         ],
    #         "txds" : [
    #             {
    #                 "hash" : "9c81dff5bcdc7909b7e3f042280583e36ab8073e3146ae70046b6f338a6dbb7a",
    #                 "pubkey" : "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
    #                 "sign" : "CeTOJSk3tCqwFTza+a9YEhaaJ9yIN/HVhdy/GmMONMg1CiN7yVggsviGo+t1\n2sK1G7dW4siCloJJIjHJbvvrmAeeI+UvK3YkWdAFbPd3uDEhj2zIAPnvMWIJ\n7/RoAYmGJtItiAn9Qznb17tAzEpg28JCMXNulzgdbdfYfB9lau241UPjzwUC\nubWhp9t/u3PAXgVmLuXhD2+JvGOaty4aKX2B/jkuY549/N2lbO2rM31CtNtN\nyBqtrUPUCyMadguueo+k6KxMfQaowb8Jwulc79GaIJzVOjHuFPBpFPRuwTQT\n1d+xnvxlt8jl+Zn0HMxCSr0Ctkr/taktqaGtatOUew==\n",
    #                 "tx" : {
    #                     "input" : {
    #                         "balance" : 1000000050,
    #                         "from" : "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #                         "to" : "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #                         "amount" : 100000,
    #                         "fee": 5,
    #                         "data": {}
    #                     },
    #                     "outputs" : [
    #                         {
    #                             "address" : "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #                             "balance" : 999900050
    #                         },
    #                         {
    #                             "address" : "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #                             "balance" : 100000
    #                         }
    #                     ],
    #                     "time" : 1567752548
    #                 }
    #             }
    #         ],
    #         "outputs" : [
    #             {
    #                 "address" : "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #                 "balance" : 999900100
    #             },
    #             {
    #                 "address" : "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #                 "balance" : 100000
    #             }
    #         ],
    #         "time" : 1567753325,
    #         "nonce" : 2179
    #     }
    # }
    # End data block nomor 2 -------------
    def self.checking_data_structure(block)
        obj = block

        if obj["hash"] && obj["hash"].class == String
            if obj["data"]["num"] && obj["data"]["num"].class == Integer
                if obj["data"]["prevhash"] && obj["data"]["prevhash"].class == String
                    if obj["data"]["tcount"] && obj["data"]["tcount"].class == Integer
                        if obj["data"]["tamount"] && obj["data"]["tamount"].class == Integer
                            if obj["data"]["diff"] && obj["data"]["diff"].class == Integer
                                if obj["data"]["mroot"] && obj["data"]["mroot"].class == String
                                    if obj["data"]["miner"] && obj["data"]["miner"].class == String
                                        if obj["data"]["reward"] && obj["data"]["reward"].class == Integer
                                            if obj["data"]["txs"] && obj["data"]["txs"].class == Array
                                                if obj["data"]["txds"] && obj["data"]["txds"].class == Array
                                                    if obj["data"]["outputs"] && obj["data"]["outputs"].class == Array
                                                        if obj["data"]["time"] && obj["data"]["time"].class == Integer
                                                            if obj["data"]["nonce"] && obj["data"]["nonce"].class == Integer
                                                                return {success: true, msg: 'incoming data structure is valid'}
                                                            else
                                                                return {success: false, msg: 'obj["data"]["nonce"] invalid'}
                                                            end
                                                        else
                                                            return {success: false, msg: 'obj["data"]["time"] invalid'}
                                                        end
                                                    else
                                                        return {success: false, msg: 'obj["data"]["outputs"] invalid'}
                                                    end
                                                else
                                                    return {success: false, msg: 'obj["data"]["txds"] invalid'}
                                                end
                                            else
                                                return {success: false, msg: 'obj["data"]["txs"] invalid'}
                                            end
                                        else
                                            return {success: false, msg: 'obj["data"]["reward"] invalid'}
                                        end
                                    else
                                        return {success: false, msg: 'obj["data"]["miner"] invalid'}
                                    end
                                else
                                    return {success: false, msg: 'obj["data"]["mroot"] invalid'}
                                end
                            else
                                return {success: false, msg: 'obj["data"]["diff"] invalid'}
                            end
                        else
                            return {success: false, msg: 'obj["data"]["tamount"] invalid'}
                        end
                    else
                        return {success: false, msg: 'obj["data"]["tcount"] invalid'}
                    end
                else
                    return {success: false, msg: 'obj["data"]["prevhash"] invalid'}
                end
            else
                return {success: false, msg: 'obj["data"]["num"] invalid'}
            end
        else
            return {success: false, msg: "hash invalid"}
        end
    end

    # == Keterangan
    # Disini divalidasi antara data dan hash. Apakah cocok atau tidak
    # chain validation between hash and data
    #
    def self.checking_hash_and_data(dataobj)

        thehash = dataobj["hash"]

        dataz = Digest::SHA256.hexdigest(dataobj["data"].to_json)

        if dataz === thehash
            return {success: true, msg: "hashing(data) == hash"}
        else
            return {success: false, msg: "hashing(data) != hash"}
        end
    end

    # == Keterangan
    # untuk mencocokkan jumlah transaksi
    def self.checking_transaction_count(block)
        obj = block

        if obj["data"]["tcount"] === obj["data"]["txs"].count
            if obj["data"]["tcount"] === obj["data"]["txds"].count
                return {success: true, msg: "transaction count is valid"}
            else
                return {success: false, msg: "transaction count is not match (2)"}
            end
        else
            return {success: false, msg: "transaction count is not match (1)"}
        end
    end

    # == Keterangan
    # Untuk mencocokkan jumlah yang ikut pada transaksi ini
    def self.checking_total_amount(block)
        obj = block

        total_ouputs = obj["data"]["outputs"].sum { |f| f["balance"] }

        if total_ouputs === obj["data"]["tamount"]
            return {success: true}
        else
            return {success: false, msg: "total amount is not match"}
        end
    end

    def self.checking_difficulty(block)
        obj = block

        if obj["hash"][0..(obj["data"]["diff"] - 1)] == "0" * obj["data"]["diff"]
            return {success: true, msg: "valid difficulty"}
        else
            return {success: false, msg: "invalid difficulty"}
        end
    end

    def self.checking_merkle(block)
        merkle_root_from_tx = Merkle.create(block["data"]["txs"])
        merkle_root_in_data = block["data"]["mroot"]

        if merkle_root_from_tx === merkle_root_in_data
            return {success: true, msg: "valid merkle root"}
        else
            return {success: false, msg: "invalid merkle root"}
        end
    end

    def self.checking_tx_datas(block)

        arr = []

        block["data"]["txds"].each do |f|

            # hash key must be string
            hkstring = JSON.parse(f.to_json)

            arr.push(Transaction.validation(hkstring)[:success])

        end

        if arr.include?(false)
            return {success: false, msg: "invalid data transaction"}
        else
            return {success: true}
        end
    end
end
