require_relative "env"

#
# cv = chain validation

class Blockchain

    def self.add(data)
        incoming_block = JSON.parse(data)

        # incoming block validation
        if Block.validation(incoming_block)[:success] === true

            if Blockchain.cv_incoming_prevhash_and_db_lasthash_match(incoming_block)[:success] === true

                return {success: true, msg: "block added"}
            else
                return Blockchain.cv_incoming_prevhash_and_db_lasthash_match(incoming_block)
            end
        else
            return Block.validation(incoming_block)
        end
    end

    private

    # == Keterangan
    # - Diambil dulu dari database untuk hash terakhir
    # - Disini divalidasi apakah pada `data yang akan ditambahkan` mempunyai previous hash yang sama dengan hash terakhir pada database
    # -----
    # - Dan juga dicocokkan, apakah `block terakhir yang ada pada database` mempunyai data[nomor_block].
    # - jika data[nomor_block] terakhir pada database ditambah 1, apakah cocok dengan data[nomor_block] pada data yang akan ditambahkan
    def self.cv_incoming_prevhash_and_db_lasthash_match(dataobj)

        # ambil data terakhir dari database
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
        dats =  client[:blockchains].find().sort({_id: -1}).limit(1).to_a

        if dats[0]["hash"] === dataobj["data"]["prevhash"]

            if (dats[0]["data"]["num"] + 1) === dataobj["data"]["num"]
                return { success: true, msg: "Incoming previous hash and last has it match" }
            else
                return { success: false, msg: "Last block + 1 is not match with incoming block" }
            end
        else
            return { success: false, msg: "db[last_hash] is not match with incoming_block[previous_hash] " }
        end
    end




end
