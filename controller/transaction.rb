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
    #     :success=>true,
    #     :data=>{
    #         :hash=>"0b535fb545fed23e4efc61a7e9185f11bade1a57504a64cec26d47aa2d65becd",
    #         :pubkey=>"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
    #         :sign=>"bXagljovmQQ6urDK+9CVxWFLjk8ghD/Z5kmrHPA0GsdR4twU3MHd0Zuyk+M/\ncRwI2BQ5k+3xyDzvWTisKYKWWisk4PfDU0+em3Qi7Q8NsdTNl43wrJLNi5JG\nWS6WXDN51xjlVdAKx3Ko/zwaqpVozT4fGGR9vCHGDCuYH1frphEs59bB5zz5\nWiTQMCfTiUpuPG9AY0HcgzxIHS1mnYRuxArhTEXGScyyRQaI1AcLybo/u7uB\nm1I7gWmp1mK3hCnINGle17cB0gf4/+ZLf0mcPD2B6nq+p2lWSlOHAf87jNRP\nGmKVmVLPXqpee+jLSXeYhZ19n87qg5nK80WLk9kAlg==\n",
    #         :tx=>{
    #             :input=>{
    #                 :balance=>1000000050,
    #                 :from=>"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #                 :to=>"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #                 :amount=>100,
    #                 :fee=>5
    #             },
    #             :outputs=>[
    #                 {:address=>"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f", :balance=>999999945},
    #                 {:address=>"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096", :balance=>100}
    #             ],
    #             :time=>1568215686
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
                                balance: from__balance_start,
                                from: data["from"],
                                to: data["to"],
                                amount: data["amount"],
                                fee: txfee
                            },
                            outputs: [
                                { address: data["from"], balance: from__output_balance },
                                { address: data["to"], balance: to__output_balance }
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

    def self.send_to_pool(transaction_data)

    end

    ##
    # == Params
    # txdata = data for a transaction form key-value hash class
    # == Data structure
    # {
    #     :hash=>"0b535fb545fed23e4efc61a7e9185f11bade1a57504a64cec26d47aa2d65becd",
    #     :pubkey=>"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
    #     :sign=>"bXagljovmQQ6urDK+9CVxWFLjk8ghD/Z5kmrHPA0GsdR4twU3MHd0Zuyk+M/\ncRwI2BQ5k+3xyDzvWTisKYKWWisk4PfDU0+em3Qi7Q8NsdTNl43wrJLNi5JG\nWS6WXDN51xjlVdAKx3Ko/zwaqpVozT4fGGR9vCHGDCuYH1frphEs59bB5zz5\nWiTQMCfTiUpuPG9AY0HcgzxIHS1mnYRuxArhTEXGScyyRQaI1AcLybo/u7uB\nm1I7gWmp1mK3hCnINGle17cB0gf4/+ZLf0mcPD2B6nq+p2lWSlOHAf87jNRP\nGmKVmVLPXqpee+jLSXeYhZ19n87qg5nK80WLk9kAlg==\n",
    #     :tx=>{
    #         :input=>{
    #             :balance=>1000000050,
    #             :from=>"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #             :to=>"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #             :amount=>100,
    #             :fee=>5
    #         },
    #         :outputs=>[
    #             {:address=>"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f", :balance=>999999945},
    #             {:address=>"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096", :balance=>100}
    #         ],
    #         :time=>1568215686
    #     }
    # }
    def self.validation(txdata)

    end

end
