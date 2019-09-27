require 'openssl'
require 'json'
require 'base64'
require 'mongo'

#require_relative "env"

class Blockchain

    @@mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

    def self.add_incoming_block(data)
        incomingobj = JSON.parse(data)

        lastblock =  Blockchain.get_last_block_in_db

        # incoming block validation
        if Block.validation(data)[:success] === true

            if Blockchain.checking_incomingprevioushash_and_dblasthash(incomingobj, lastblock)[:success] === true

                if Blockchain.checking_incomingtime_and_dblasttime(incomingobj, lastblock)[:success] === true
                    # add to db karena semua sudah valid
                    @@mongoclient[:blockchains].insert_one(incomingobj)

                    return {success: true}
                else
                    return Blockchain.checking_incomingtime_and_dblasttime(incomingobj, lastblock)
                end
            else
                return Blockchain.checking_incomingprevioushash_and_dblasthash(incomingobj, lastblock)
            end
        else
            return Block.validation(data)
        end
    end

    def self.checking_incomingprevioushash_and_dblasthash(dataobj, lastblock)

        if lastblock["hash"] === dataobj["data"]["prevhash"]

            if (lastblock["data"]["num"] + 1) === dataobj["data"]["num"]
                return { success: true, msg: "Incoming previous hash and last has it match" }
            else
                return { success: false, msg: "Last block + 1 is not match with incoming block" }
            end
        else
            return { success: false, msg: "db[last_hash] is not match with incoming_block[previous_hash] " }
        end
    end

    def self.checking_incomingtime_and_dblasttime(dataobj, lastblock)

        # puts "lastblock " + lastblock["data"]["time"].to_s
        # puts "incomingblock " + dataobj["data"]["time"].to_s
        # puts "lastblock+5 " + (lastblock["data"]["time"] + (5*60)).to_s

        # block dibuat setiap 5 menit
        if dataobj["data"]["time"] > lastblock["data"]["time"] + (5*60)
            return { success: true }
        else
            return { success: false, msg: "invalid, block time created too fast" }
        end
    end

    def self.get_last_block_in_db
        lastblocks =  @@mongoclient[:blockchains].find().sort({_id: -1}).limit(1).to_a

        return lastblocks[0]
    end

end
