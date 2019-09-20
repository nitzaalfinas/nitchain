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

        # cek dulu apakah transaksi sudah ada
        if mongoclient[:pools].find({hash: trxobj["hash"]}).to_a.count === 0

            # kalkulasi balance
            if Pool.add_balance_calculation(mongoclient, trxobj["data"] )[:success] === true

                # simpan dalam database pools
                mongoclient[:pools].insert_one(trxobj)

                return {success: true, msg: ""}
            else
                return Pool.add_balance_calculation(mongoclient, trxobj["data"] )
            end
        else
            return {success: false, msg: "transaction exists"}
        end
    end

    # "data" : {
    #     "from" : "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #     "to" : "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #     "amount" : 100,
    #     "fee" : 5,
    #     "data" : {},
    #     "time" : 1568933789
    # }
    def self.add_balance_calculation(mongoclient, txdata)

        # STEP 1. KALKULASI SEMUA BALANCE FROM
        @from__balance_start = Wallet.balance(txdata["from"])[:data][:balance]

        # DIKURANGI dulu dengan transaksi yang akan diletakkan di pool
        @from__balance_start = @from__balance_start - txdata["amount"] - txdata["fee"]

        if @from__balance_start > 0

            # jika ada transaksi yang datang dari sender, maka balance dia berkurang. termasuk dikurangi juga dengan fee
            # DIKURANGI
            mongoclient[:pools].find({"data.from": txdata["from"]}).to_a.each do |fb|
                @from__balance_start =  @from__balance_start - fb["amount"] - fb["fee"]
            end

            # jika ada transaksi yang menuju dia, maka balance sender akan bertambah
            # DITAMBAHKAN
            mongoclient[:pools].find({"data.to": txdata["from"]}).to_a.each do |fb|
                @from__balance_start =  @from__balance_start + fb["amount"]
            end

            if @from__balance_start > 0

                # STEP 2. KALKULASI SEMUA BALANCE TO
                @to__balance_start = Wallet.balance(txdata["to"])[:data][:balance]

                # DITAMBAHKAN dulu dengan transaksi yang akan diletakkan di pool. Tetapi tidak ditambahkan dengan fee!
                @to__balance_start = @to__balance_start + txdata["amount"]

                if @to__balance_start > 0

                    # DITAMBAHKAN
                    mongoclient[:pools].find({"data.to": txdata["to"]}).to_a.each do |fb|
                        @to__balance_start =  @to__balance_start + fb["amount"]
                    end

                    # jika ada transaksi yang menuju dia, juga dikalkulasi
                    # DIKURANGI
                    mongoclient[:pools].find({"data.from": txdata["to"]}).to_a.each do |fb|
                        @to__balance_start =  @to__balance_start - fb["amount"] - fb["fee"]
                    end

                    if @to__balance_start > 0

                        # cari dan masukkan data kedalam pools (from)
                        mongoclient[:poolouts].find({address: txdata["from"]}).delete_many()
                        mongoclient[:poolouts].insert_one({address: txdata["from"], balance: @from__balance_start })

                        # cari dan masukkan data kedalam pools (to)
                        mongoclient[:poolouts].find({address: txdata["to"]}).delete_many()
                        mongoclient[:poolouts].insert_one({address: txdata["to"], balance: @to__balance_start })

                        return {success: true, msg: "", data: [
                            {address: txdata["from"], balance: @from__balance_start },
                            {address: txdata["to"], balance: @to__balance_start }
                        ]}
                    else
                        return {success: false, msg: "destination balance can't be below zero (2)"}
                    end
                else
                    return {success: false, msg: "destination balance can't be below zero (1)"}
                end

            else
                return {success: false, msg: "sender balance can't be below zero (2)"}
            end
        else
            return {success: false, msg: "sender balance can't be below zero (1)"}
        end

    end

end
