require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative "env"

class Mine

    # bagian ini untuk dia mine
    def self.mine
        mongclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        transactions = Mine.get_all_data_in_the_pool(mongclient)

        total_ouput_transactions = 0  # all summary outputs in the transactions
        array_of_hash = []            # array of hash for creating merkle root and tree
        transactions.each do |t|
            total_ouput_transactions = total_ouput_transactions + t["tx"]["outputs"].sum { |f| f["balance"] }
            array_of_hash.push(t["hash"])
        end

        lastblock = Blockchain.get_last_block_in_db

        # buat variabel disini supaya nanti bisa diganti-ganti
        mining_reward = 50

        # mining sama dengan membuat block baru!
        newblock = {}
        newblock[:data] = {
            num: lastblock["data"]["num"] + 1,
            prevhash: lastblock["hash"],
            tcount: transactions.size,
            tamount: total_ouput_transactions + mining_reward,
            diff: 3,
            mroot: Merkle.create(array_of_hash),
            miner: BASE_ADDRESS,
            reward: mining_reward,
            txs: array_of_hash,
            txds: transactions
        }

        return newblock

    end

    def self.get_all_data_in_the_pool(mongclient)
        datas = []
        mongclient[:pools].find().to_a.each do |f|

            f.delete("_id")

            datas.push(f)
        end

        return datas
    end

end
