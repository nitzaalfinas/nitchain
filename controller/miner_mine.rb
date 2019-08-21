class MinerMine

    def self.save_pubkey
        
    end


    def self.mine 
        merkle_root = Miner.create_merkle

        data = {}
        data[:hash] = ""
        data[:time] = ""
        data[:difficulty] = ""
        data[:transactions] = ""
        data[:total] = ""
        data[:merkle_root] = merkle_root
        data[:nonce] = ""

        

    end



    # Todo:
    # Sebelum buat merkle tree, hash harus diperiksan. Hash tidak boleh ada yang sama!
    def self.create_merkle

        puts "saya dipanggil"
        puts "database name " + DATABASE_NAME

        # ambil semua data dari pool
        Mongo::Logger.logger.level = ::Logger::FATAL

        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)  
        items = client[:pools].find({})

        # hitung jumlah data 
        # puts items.count
        
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
        merkles_arr = []
        merkles.each do |f|
            merkles_arr.push(f["hash"])
        end
        # puts "merkles_arr"
        # puts merkles_arr.to_s

        loop do

            merkles_arr = MinerMine.merkle_proses(merkles_arr)

            # puts "merkles_arr"
            # puts merkles_arr.to_s
            # puts merkles_arr.count
            
            if merkles_arr.count == 1
                break 
            end
        end

        # hasil akhir ini adalah merkle root!
        return merkles_arr

    end

    def self.merkle_proses(merkles_arr)

        # cek juga jumlah merkle array terlebih dahulu, jika ganjil, maka tambahkan satu dibelakang
        # penggunaan ini cukup menarik pada tutorial ini https://stackoverflow.com/questions/18163475/ruby-check-if-even-number-float
        genap_ganjil = merkles_arr.count / 2.0
        # puts genap_ganjil
        if genap_ganjil.round.even? == true
            merkles_arr.push(merkles_arr.last)
        end

        nu_arr = []
        urut = 0
        merkles_arr.each do |f|
            urut = urut + 1
            if urut % 2 == 0
                # puts ""
                # puts "--->"
                # puts urut
                # puts merkles_arr[urut-2]
                # puts merkles_arr[urut-1]

                # gabungkan hash
                hash_join = merkles_arr[urut-2] + merkles_arr[urut-1]

                # buat hash baru dari yang sudah digabungkan 
                nuhash = Digest::SHA1.hexdigest(hash_join)

                nu_arr.push(nuhash)
            end
        end

        return nu_arr
    end
end