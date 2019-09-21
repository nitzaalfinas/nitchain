require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative "env"

class Mine

    # bagian ini untuk dia mine
    def self.mine
        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        lastblock = Blockchain.get_last_block_in_db
        blocknumber_to_mine = lastblock["data"]["num"] + 1

        transactions = Mine.get_all_data_in_the_pool(mongoclient)

        outputs = Mine.get_all_pool_output(mongoclient, blocknumber_to_mine)

        total_ouput_transactions = 0  # all summary outputs in the transactions
        hash_array = []            # array of hash for creating merkle root
        transactions.each do |t|
            hash_array.push(t["hash"])
        end

        hash_array_for_txs = []
        transactions.each do |t|
            hash_array_for_txs.push(t["hash"])
        end

        # buat variabel disini supaya nanti bisa diganti-ganti
        mining_reward = 50

        # mining sama dengan membuat block baru!
        newblock = {}
        newblock[:data] = {}
        newblock[:data][:num] = blocknumber_to_mine
        newblock[:data][:prevhash] = lastblock["hash"]
        newblock[:data][:tcount] = transactions.size
        newblock[:data][:tamount] = total_ouput_transactions + mining_reward
        newblock[:data][:diff] = 3
        newblock[:data][:mroot] = Merkle.create(hash_array) # merkle root bisa merubah hash_array. Jadi, disini harus dipisahkan
        newblock[:data][:miner] = BASE_ADDRESS
        newblock[:data][:reward] = mining_reward
        newblock[:data][:txs] = hash_array_for_txs
        newblock[:data][:txds] = transactions
        newblock[:data][:outputs] = outputs
        newblock[:data][:time] = Time.now.utc.to_i

        # 1.3. Mine!
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

        newblock[:hash] = minehash

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
