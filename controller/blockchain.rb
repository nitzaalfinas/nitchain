require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative "env"

class Blockchain

    def self.add_incoming_block(data)

        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        incomingobj = JSON.parse(data)

        lastblock =  Blockchain.get_last_block_in_db

        # incoming block validation
        if Block.validation(data)[:success] === true

            if Blockchain.checking_incomingprevioushash_and_dblasthash(incomingobj, lastblock)[:success] === true

                if Blockchain.checking_incomingtime_and_dblasttime(incomingobj, lastblock)[:success] === true
                    # add to db karena semua sudah valid
                    mongoclient[:blockchains].insert_one(incomingobj)

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

        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        lastblocks =  mongoclient[:blockchains].find().sort({_id: -1}).limit(1).to_a

        return lastblocks[0]
    end

    def self.get_block_by_number(number)

        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        blocks =  mongoclient[:blockchains].find({"data.num": number}).sort({_id: -1}).limit(1).to_a

        return blocks[0]
    end

    # == Keterangan
    # minta data dari server yang sedang aktif
    def self.sync(data)

        parameter = JSON.parse(data)

        loop do
            socket = TCPSocket.new($root_ip, $root_port)

            # periksa block terakhir yang ada pada blockchain
            lastblock =  Blockchain.get_last_block_in_db

            lastblock.delete("_id")

            next_block_id = lastblock["data"]["num"] + 1

            # minta data
            socket.write({command: "sync_ask_block", data: next_block_id}.to_json + "\n")
            kembalian = socket.gets
            socket.close

            obj = JSON.parse(kembalian)

            if obj["success"] === true
                puts Blockchain.add_incoming_block(obj["data"].to_json)
            else
                puts obj["msg"]
            end

            sleep parameter["timesleep"]
        end
    end
end
