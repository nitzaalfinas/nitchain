require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative "env"

class Pool

    # == Keterangan
    # data-data ini didapatkan dari kiriman user-user yang ingin melakukan transaksi
    def self.add(transaction_data_in_json_string)

        trxobj = JSON.parse(transaction_data_in_json_string)

        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        if Pool.checking_data_is_not_exists(mongoclient, trxobj)[:success] === true
            mongoclient[:pools].insert_one(trxobj)
        else
            return Pool.checking_data_is_not_exists(mongoclient, trxobj)
        end
    end

    def self.checking_data_is_not_exists(mongoclient, trxobj)

        jumlah = mongoclient[:pools].find({hash: trxobj["hash"]}).to_a.count

        if jumlah === 0
            return {success: true}
        else
            return {success: false, msg: "transaction data exists"}
        end
    end

end
