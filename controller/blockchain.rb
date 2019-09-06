class Blockchain

    def self.add(data)
        dataobj = JSON.parse(data)

        if Blockchain.cv_a_hash_exists?(dataobj) === false

            if Blockchain.cv_b_hash_and_data(dataobj) === true

                if Blockchain.cv_c_prev_hash_and_block_number(dataobj) === true

                    return {
                        success: true,
                        msg: "!"
                    }
                else
                    return {
                        success: false,
                        msg: "Previous hash or block number is not match!"
                    }
                end
            else
                return {
                    success: false,
                    msg: "Hash and data is not match!"
                }
            end
        else
            return {
                success: false,
                msg: "Hash exists!"
            }
        end

    end

    def self.cv_a_hash_exists?(dataobj)

        # ambil data terakhir dari database
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
        if client[:blockchains].find({hash: dataobj["hash"] }).count === 1
            return true
        else
            return false
        end
    end

    # chain validation between hash and data
    def self.cv_b_hash_and_data(dataobj)

        thehash = dataobj["hash"]

        dataz = Digest::SHA256.hexdigest(dataobj["data"].to_json)

        if dataz === thehash
            return true
        else
            return false
        end
    end

    def self.cv_c_prev_hash_and_block_number(dataobj)

        # ambil data terakhir dari database
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
        dats =  client[:blockchains].find().sort({_id: -1}).limit(1).to_a

        if dats[0]["hash"] === dataobj["data"]["prevhash"]

            if (dats[0]["data"]["num"] + 1) === dataobj["data"]["num"]
                return true
            else
                return false
            end
        else
            return false
        end
    end

end
