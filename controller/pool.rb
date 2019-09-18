require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative "env"

class Pool

    # == Keterangan
    # data-data ini didapatkan dari kiriman user-user yang ingin melakukan transaksi
    def self.add(data_json)
        # ambil data terakhir dari database disini. supaya tidak diquery berulangkali
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
        client[:pools].find()

    end

    def self.checking_valid_incoming_data
    end

end
