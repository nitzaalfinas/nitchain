require_relative "env"

class Transaction

    attr_accessor :hash, :tx

    def initialize(hash, tx)
        @hash = hash
        @tx = tx
    end

    ##
    # == Keterangan
    # Creating transaction from json data
    #
    # == Params
    # tx = hash
    #
    # == Return
    # {
    #     "success":true,
    #     "data":{
    #         "hash":"f45a614f0725d9981182735af505af71e02bfa0c56958ba648dd9cee9b63eb5a",
    #         "pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
    #         "sign":"blDZiWejsa/B6EKWS4LBgXxsZi/LYFxJ0uQ+NvNKL1GhhT6BpxxEB7HyVTAd\n7EvRumkKofeHzQBwJdFLeNwGfpBjvTfi2S1lDOU0gSHZdFPOUDWyDfZl56f5\nHhJaSS0F1L/mEER1qUVwSqTVIFsUSEwDfcN6pnMsQO61QjYTKAAKngFevy3+\nQalEDh3xxSWd/47i11tn2Gr4plFKzAjPJNoUrOvzVrPXbRjFw3oUrKBqGO1T\nJCeQ0nhbjIU5DtMExdNnjXP2l7OPB56VziXRGNC0kMMp394WYIKKJV+6rz2i\nslA6O816o5Q3DYqmXJHTQ4mVqds8LEWxmVmNacTxsg==\n",
    #         "tx":{
    #             "input":{
    #                 "balance":1000000050,
    #                 "from":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #                 "to":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #                 "amount":100,
    #                 "fee":5,
    #                 "data":{}
    #             },
    #             "outputs":[
    #                 {"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":999999945},
    #                 {"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":100}
    #             ],
    #             "time":1568218748
    #         }
    #     }
    # }
    def self.create(datainput)
        data = JSON.parse(datainput)

        if Wallet.validation_address_format(data["from"])[:success] === true && Wallet.validation_address_format(data["to"])[:success] === true

            if Wallet.validation_key_and_get_pubkey(data["from"])[:success] === true

                my_key_data = Wallet.get_data_key_and_content_validation(data["from"])

                from__balance_start = Wallet.balance(data["from"])[:data][:balance]
                txfee = 5

                from__output_balance = from__balance_start - (data["amount"] + txfee)

                if from__output_balance > 0

                    to__balance_start = Wallet.balance(data["to"])[:data][:balance]
                    to__output_balance = to__balance_start + data["amount"]

                    if to__output_balance > 0

                        datasend = {
                            input: {
                                from: data["from"],
                                balance: from__balance_start,
                                to: data["to"],
                                amount: data["amount"],
                                fee: txfee,
                                data: {}
                            },
                            outputs: [
                                { address: data["from"], balance: from__output_balance },
                                { address: data["to"], balance: to__output_balance },
                                { address: "miner", balance: txfee },
                            ],
                            time: Time.now.utc.to_i
                        }

                        # txhash
                        txhash = Digest::SHA256.hexdigest(datasend.to_json.to_s)

                        # my public key
                        my_pubkey = my_key_data[:data][:pubkey]

                        # my private key
                        my_privkey_text = my_key_data[:data][:privkey]

                        # sign message
                        my_privkey = OpenSSL::PKey::RSA.new(my_privkey_text)
                        signature = Base64.encode64( my_privkey.sign(OpenSSL::Digest::SHA256.new, datasend.to_json.to_s) )

                        return {
                            success: true,
                            data: {
                                hash: txhash,
                                pubkey: my_pubkey,
                                sign: signature,
                                tx: datasend
                            }
                        }
                    else
                        return {success: false, msg: "To balance can't be below 0"}
                    end
                else
                    return {success: false, msg: "From balance is not enough"}
                end
            else
                return Wallet.validation_key_and_get_pubkey(data["from"])
            end
        else
            return Wallet.validation_address_format(data["from"])
        end
    end

    ##
    # == Keterangan
    # kirim saja kepada server pusat terlebih dahulu
    def self.send_to_pool(transaction_data)

    end

    ##
    # == Params
    # txdata = data for a transaction form key-value hash class
    # == Data structure
    # {
    #     "hash":"f45a614f0725d9981182735af505af71e02bfa0c56958ba648dd9cee9b63eb5a",
    #     "pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
    #     "sign":"blDZiWejsa/B6EKWS4LBgXxsZi/LYFxJ0uQ+NvNKL1GhhT6BpxxEB7HyVTAd\n7EvRumkKofeHzQBwJdFLeNwGfpBjvTfi2S1lDOU0gSHZdFPOUDWyDfZl56f5\nHhJaSS0F1L/mEER1qUVwSqTVIFsUSEwDfcN6pnMsQO61QjYTKAAKngFevy3+\nQalEDh3xxSWd/47i11tn2Gr4plFKzAjPJNoUrOvzVrPXbRjFw3oUrKBqGO1T\nJCeQ0nhbjIU5DtMExdNnjXP2l7OPB56VziXRGNC0kMMp394WYIKKJV+6rz2i\nslA6O816o5Q3DYqmXJHTQ4mVqds8LEWxmVmNacTxsg==\n",
    #     "tx":{
    #         "input":{
    #             "balance":1000000050,
    #             "from":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #             "to":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #             "amount":100,
    #             "fee":5,
    #             "data":{}
    #         },
    #         "outputs":[
    #             {"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":999999945},
    #             {"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":100}
    #             {"address":"miner","balance":5}
    #         ],
    #         "time":1568218748
    #     }
    # }
    def self.validation(txdata)

        if txdata["hash"] && txdata["pubkey"] && txdata["sign"] && txdata["tx"] && txdata["tx"]["input"] && txdata["tx"]["input"]["balance"] && txdata["tx"]["input"]["from"] && txdata["tx"]["input"]["to"] && txdata["tx"]["input"]["amount"] && txdata["tx"]["input"]["fee"] && txdata["tx"]["input"]["data"] && txdata["tx"]["outputs"] && txdata["tx"]["time"]

            # compare hash and tx-in-json
            if txdata["hash"] === Digest::SHA256.hexdigest(txdata["tx"].to_json.to_s)

                # check apakah address from dan address to valid?
                if Wallet.validation_address_format(txdata["tx"]["input"]["from"])[:success] === true && Wallet.validation_address_format(txdata["tx"]["input"]["to"])[:success] === true

                    # check apakah sha1 pubkey sama dengan from
                    if "Nx#{Digest::SHA1.hexdigest(txdata["pubkey"])}" === txdata["tx"]["input"]["from"]

                        if txdata["tx"]["input"]["genesis"] != true

                            from__balance_start = Wallet.balance(txdata["tx"]["input"]["from"])[:data][:balance]

                            # check sender balance start
                            if from__balance_start === txdata["tx"]["input"]["balance"]

                                # check sender balance start lebih besar dari (amount + fee )
                                # fee juga tidak boleh minus
                                if from__balance_start >= txdata["tx"]["input"]["amount"] + txdata["tx"]["input"]["fee"] && txdata["tx"]["input"]["fee"] > 0

                                    to__balance_start = Wallet.balance(txdata["tx"]["input"]["to"])[:data][:balance]

                                    # cek to__balance_start + amount sama dengan outputs
                                    if to__balance_start + txdata["tx"]["input"]["amount"] === txdata["tx"]["outputs"][1]["balance"]

                                        # cek apakah outputs miner balance pada transaksi ini sama dengan fee
                                        if txdata["tx"]["outputs"][2]["balance"] === txdata["tx"]["input"]["fee"]

                                            return {success: true}
                                        else
                                            return {success: false, msg: "invalid outputs fee for miner"}
                                        end
                                    else
                                        return {success: false, msg: "invalid to outputs"}
                                    end
                                else
                                    return {success: false, msg: "invalid, balance is not enough"}
                                end
                            else
                                return {success: false, msg: "invalid tx start sender balance"}
                            end
                        elsif txdata["tx"]["input"]["genesis"] === true

                            ### HARD CODE GENESIS (SAMAKAN DENGAN YANG DI TEST DAN YANG ADA DI DATABASE)
                            if txdata["tx"]["input"]["from"] === "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f" &&
                                    txdata["tx"]["input"]["balance"] === 1000000000 &&
                                    txdata["tx"]["input"]["to"] === "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096" &&
                                    txdata["tx"]["input"]["amount"] === 1000000000 &&
                                    txdata["tx"]["input"]["fee"] === 0

                                return {success: true}
                            else
                                return {success: false, msg: "invalid genesis"}
                            end
                        end
                    else
                        return {success: false, msg: "invalid comparison address from and public key"}
                    end
                else
                    return {success: false, msg: "invalid address from or to"}
                end
            else
                return {success: false, msg: "invalid comparison hash and tx"}
            end
        else
            return {success: false, msg: "invalid transaction format"}
        end
    end


end
