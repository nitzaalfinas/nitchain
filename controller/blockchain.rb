require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative "env"

class Blockchain

    def self.add_incoming_block(data)
        incomingobj = JSON.parse(data)

        # incoming block validation
        if Block.validation(data)[:success] === true

            if Blockchain.checking_incomingprevioushash_and_dblasthash(incomingobj)[:success] === true

                return {success: true}
            else
                return Blockchain.checking_incomingprevioushash_and_dblasthash(incomingobj)
            end
        else
            return Block.validation(data)
        end
    end

    def self.checking_incomingprevioushash_and_dblasthash(dataobj)
        # ambil data terakhir dari database
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
        dats =  client[:blockchains].find().sort({_id: -1}).limit(1).to_a

        if dats[0]["hash"] === dataobj["data"]["prevhash"]

            if (dats[0]["data"]["num"] + 1) === dataobj["data"]["num"]
                puts "243"
                return { success: true, msg: "Incoming previous hash and last has it match" }
            else
                puts "df"
                return { success: false, msg: "Last block + 1 is not match with incoming block" }

            end
        else
            return { success: false, msg: "db[last_hash] is not match with incoming_block[previous_hash] " }
        end
    end

end
