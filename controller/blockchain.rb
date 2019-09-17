require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative "env"

class Blockchain

    def self.add_incoming_block(data)
        incomingobj = JSON.parse(data)

        # ambil data terakhir dari database disini. supaya tidak diquery berulangkali
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
        lastblocks =  client[:blockchains].find().sort({_id: -1}).limit(1).to_a

        # incoming block validation
        if Block.validation(data)[:success] === true

            if Blockchain.checking_incomingprevioushash_and_dblasthash(incomingobj, lastblocks[0])[:success] === true

                if Blockchain.checking_incomingtime_and_dblasttime(incomingobj, lastblocks[0])[:success] === true
                    # add to db karena semua sudah valid
                    client[:blockchains].insert_one(incomingobj)

                    return {success: true}
                else
                    return Blockchain.checking_incomingtime_and_dblasttime(incomingobj, lastblocks[0])
                end
            else
                return Blockchain.checking_incomingprevioushash_and_dblasthash(incomingobj, lastblocks[0])
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

        puts "lastblock " + lastblock["data"]["time"].to_s
        puts "incomingblock " + dataobj["data"]["time"].to_s
        puts "lastblock+5 " + (lastblock["data"]["time"] + (5*60)).to_s

        # block dibuat setiap 5 menit
        if dataobj["data"]["time"] > lastblock["data"]["time"] + (5*60)
            return { success: true }
        else
            return { success: false, msg: "invalid, block time created too fast" }
        end
    end

end
