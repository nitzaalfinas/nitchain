class MinerMine

    def self.save_pubkey
        
    end

    def self.pool_submit 

    end

    def self.create_merkle

        puts "saya dipanggil"
        puts "database name " + DATABASE_NAME

        # ambil semua data dari pool
        Mongo::Logger.logger.level = ::Logger::FATAL

        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)  
        items = client[:pools].find({})

        # hitung jumlah data 
        puts items.count
        
        #puts client[:pools].

        # AKTIFKAN LAGI NANTI SETELAH BISA MEMBUAT MERKLE TREE!
        # ambil yang ada dalam database semua dan update field: creating_merkle => true
        # pos = 0
        # items.each do |x|
        #     client[:pools].update_one({"_id" => x["_id"]}, {"$set" => {"creating_merkle" => true}})

        #     # berikan posisi pada merkle tree
        #     pos = pos + 1
        #     x[:position] = pos
        #     x[:leaf] = true
        #     client[:merkles].insert_one(x)
        # end
        
        merkles = client[:merkles].find({"creating_merkle" => true})
        merkles_arr = merkles.to_a
        # puts merkles_arr

        if MinerMine.merkle_proses(merkles, merkles_arr).count != 0
            
        end


    end

    def self.merkle_proses(merkles, merkles_arr)

        arr_hash = []
    
        urut = 0
        merkles.each do |f|
            urut = urut + 1
            if urut % 2 == 0
                puts ""
                puts "--->"
                puts urut
                puts merkles_arr[urut-2]["hash"]
                puts merkles_arr[urut-1]["hash"]

                arr_hash.push(merkles_arr[urut-2]["hash"] + "**" + merkles_arr[urut-1]["hash"])
            end
        end

        return arr_hash
    end
end