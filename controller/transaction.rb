require_relative "env"

class Transaction

    ##
    # == Params
    # txdata = data for a transaction form key-value hash class
    # == Data structure
    # {
    #     "hash": "a3de365c86430d86f0ff2a0d126024026c0669dabf53957f99b0e0a7046276ee",
    #     "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
    #     "sign": "I+WWwxBoJrwDdCiX2LYevo1xciUmUCXlz2bYz1yzj4j69ftApMjakl/PSY1L\nPMIqyUb3qnUuwOn+ALb+7e3ip+UEWq3vtwGV9nn1lCaEzfdEaaAqAovKHZwz\nXSTW1JBp8r5KzWGuezMmgJCjZHM1yvO/2NOxWe3I2l1BZwluoUx1PNkMt5Nh\nWdzjGx2oL5kffBMNB+Zzn2N/ejYx00dzcanJ6x9UPFq6Wh9xp87vEU51IvyH\n2aOeOaa7KSKe24TbuITVqteBPh+vvOz2CPoQEYkZD5lVkNhgvACG5B0fz524\n9KXumni5aOUB9ZOH2zMBhF2AUb3LHPdodVxdrRtmmA==\n",
    #     "tx": {
    #         "block": 1,
    #         "from": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #         "to": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #         "amount": 1000000000,
    #         "fee": 0,
    #         "data": {},
    #         "time": 1567676889
    #     }
    # }
    def self.validation(txdata)

        if txdata["hash"] && txdata["pubkey"] && txdata["sign"] && txdata["tx"] && txdata["tx"]["block"] && txdata["tx"]["from"] && txdata["tx"]["to"] && txdata["tx"]["amount"] && txdata["tx"]["fee"] && txdata["tx"]["data"] && txdata["tx"]["time"]

            # puts"a1"

            # compare hash and tx-in-json
            if txdata["hash"] === Digest::SHA256.hexdigest(txdata["tx"].to_json.to_s)

                # puts"a2"

                # check apakah address from dan address to valid?
                if Wallet.validation_address_format(txdata["tx"]["from"])[:success] === true && Wallet.validation_address_format(txdata["tx"]["to"])[:success] === true

                    # puts"a3"

                    # check apakah sha1 pubkey sama dengan from
                    if "Nx#{Digest::SHA1.hexdigest(txdata["pubkey"])}" === txdata["tx"]["from"]

                        # puts"a4"

                        if txdata["tx"]["block"] > 1

                            # puts"a5"

                            if txdata["tx"]["fee"] > 0
                                return {success: true}
                            else
                                return {success: false, msg: "fee can't be zero"}
                            end
                        elsif txdata["tx"]["block"] === 1

                            ### HARD CODE GENESIS (SAMAKAN DENGAN YANG DI TEST DAN YANG ADA DI DATABASE)
                            if txdata["tx"]["from"] === "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f" &&
                                    txdata["tx"]["to"] === "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096" &&
                                    txdata["tx"]["amount"] === 1000000000 &&
                                    txdata["tx"]["fee"] === 0

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
