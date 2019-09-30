require 'openssl'
require 'json'
require 'base64'
require 'mongo'

#require_relative "env"

class Mine

    # bagian ini untuk dia mine
    def self.mine
        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        # 1. get last block in database
        lastblock = Blockchain.get_last_block_in_db

        # 2. what number block to mine?
        blocknumber_to_mine = lastblock["data"]["num"] + 1

        # 3. get all transactions in the pool
        transactions = Mine.get_all_data_in_the_pool(mongoclient)

        # 4. get all the pool output transactions (balance end result)
        outputs = Mine.get_all_pool_output(mongoclient, blocknumber_to_mine)

        # 5. array of hash for each transactions
        hash_array = []
        hash_array_for_txs = []
        transactions.each do |t|
            hash_array.push(t["hash"])                     # using for merkle calculation
            hash_array_for_txs.push(t["hash"])             # using for storing in the chain. We can't user `hash_array` because it become 2 array if it store in the block. Because of merkle calculation
        end

        # 6. buat variabel disini supaya nanti bisa diganti-ganti
        mining_reward = 50

        # 7. we can use outputs array to get total outputs
        tamount = outputs[:balances].sum { |f| f[:balance] }

        # 8. tfee
        tfee = outputs[:miner_fee]

        # 9. mining sama dengan membuat block baru!
        newblock = {}
        newblock[:hash] = nil                              # letakkan disini supaya urutan hashnya nanti jadi benar
        newblock[:data] = {}
        newblock[:data][:num] = blocknumber_to_mine
        newblock[:data][:prevhash] = lastblock["hash"]
        newblock[:data][:tcount] = transactions.size
        newblock[:data][:tamount] = tamount
        newblock[:data][:diff] = 3
        newblock[:data][:mroot] = Merkle.create(hash_array) # merkle root bisa merubah hash_array. Jadi, disini harus dipisahkan
        newblock[:data][:miner] = BASE_ADDRESS
        newblock[:data][:reward] = mining_reward
        newblock[:data][:tfee] = tfee
        newblock[:data][:txs] = hash_array_for_txs
        newblock[:data][:txds] = transactions
        newblock[:data][:outputs] = outputs[:balances]
        newblock[:data][:time] = Time.now.utc.to_i

        # 10. Mine!
        minehash = ""
        nonce = 0
        loop do
            #block[:time] = Time.now.utc.to_i # ini harus selalu diatas nonce
            newblock[:data][:nonce] = nonce
            minehash = Digest::SHA256.hexdigest(newblock[:data].to_json)

            nonce = nonce + 1

            # find leading zero
            if minehash[0..(newblock[:data][:diff]-1)] == "0" * newblock[:data][:diff]
                break
            end
        end

        # 11. replace hash
        newblock[:hash] = minehash

        # 12. BROADCAST NEW BLOCK!!!!
        socket = TCPSocket.new($root_ip, $root_port)
        socket.write({command: "broadcast_new_block", data: newblock}.to_json + "\n")

        # 13. minta data yang kembali
        socket_return = socket.gets # baca response yang didapatkan

        # 14. insert into db if it success
        obj_socket_return = JSON.parse(socket_return)
        if obj_socket_return["success"] === true
            Blockchain.add_incoming_block(obj_socket_return["data"].to_json)

            # 14.1. hapus data yang di pools
            mongoclient[:pools].delete_many()

            # 14.2. hapus data yang ada di poolouts
            mongoclient[:poolouts].delete_many()

        end

        socket.close

        return newblock
    end

    def self.get_all_data_in_the_pool(mongoclient)
        datas = []
        mongoclient[:pools].find().to_a.each do |f|

            f.delete("_id")

            datas.push(f)
        end

        return datas
    end

    # kalkulasi juga fee reward + fee ditambahkan kepada miner
    def self.get_all_pool_output(mongoclient, blocknumber_to_mine)

        miner_fee = mongoclient[:poolouts].find({address: 'miner'}).to_a[0][:balance]

        # yang dalam poolouts + miner_fee + reward
        miner_balance = mongoclient[:poolouts].find({address: BASE_ADDRESS}).to_a[0][:balance] + miner_fee + 50

        # Jangan sertakan miner jika ada
        datas = []
        mongoclient[:poolouts].find().to_a.each do |f|
            if f["address"] != BASE_ADDRESS && f["address"] != 'miner'
                f.delete("_id")
                datas.push(f)
            end
        end

        # masukkan miner
        datas.push({address: BASE_ADDRESS, balance: miner_balance})

        return {
            balances: datas,
            miner_fee: miner_fee
        }
    end

end
