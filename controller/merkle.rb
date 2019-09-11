class Merkle

    def self.create(array_of_hash)
        merkles_arr = array_of_hash

        loop do
            merkles_arr = Merkle.create_proses(merkles_arr)

            if merkles_arr.count == 1
                break
            end
        end

        return merkles_arr[0]

    end

    private

    def self.create_proses(merkles_arr)

        # cek juga jumlah merkle array terlebih dahulu, jika ganjil, maka tambahkan satu dibelakang
        if merkles_arr.size.odd? === true
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
                nuhash = Digest::SHA256.hexdigest(hash_join)

                nu_arr.push(nuhash)
            end
        end

        return nu_arr
    end
end
