class WalletOld

    def self.create
        key = OpenSSL::PKey::RSA.new(2048)

        kembali = {}
        kembali[:privkey] = key.to_pem
        kembali[:pubkey] =  key.public_key.to_pem
        kembali[:address] =  "Nx#{Digest::SHA1.hexdigest(kembali[:pubkey])}"
        kembali[:created] = Time.now.utc

        File.open("#{KEYSTORE_PATH}/#{kembali[:address]}", 'w') { |f| f.write(kembali.to_json.to_s) }

        kembali[:address]
    end

    # == Penjelasan
    # Pada bagian ini, transaksi harus ditransfer dan di hash
    def self.transfer(from, to, amount)

        data = {}
        data[:from] = from
        data[:to] = to
        data[:amount] = amount
        data[:time] = Time.now.utc.to_i

        main_pubkey_file = "#{MAIN_CONFIG_PATH}/main_pubkey"
        text = data.to_json

        is_this_valid_sender_file_address = Wallet.valid_sender_file_address?(data[:from])

        # cek dulu, apakah sender punya file private key
        if is_this_valid_sender_file_address === true

            mykey_text = File.read("#{KEYSTORE_PATH}/#{from}")
            mykey_file_obj = JSON.parse(mykey_text)

            my_privkey = OpenSSL::PKey::RSA.new(mykey_file_obj["privkey"])
            signature = Base64.encode64( my_privkey.sign(OpenSSL::Digest::SHA256.new, text) )

            destination_public_key = OpenSSL::PKey::RSA.new(File.read(main_pubkey_file))
            hash_string = Digest::SHA1.hexdigest(text)
            public_encrypt = destination_public_key.public_encrypt(text)
            encrypted_string = Base64.encode64(public_encrypt)

            sender_public_key_obj = Wallet.sender_key_obj(from)
            sender_public_key = sender_public_key_obj["pubkey"]

            data_to_submit = {}
            data_to_submit[:data] = data
            data_to_submit[:hash] = hash_string
            data_to_submit[:enc] = encrypted_string
            data_to_submit[:sign] = signature
            data_to_submit[:pubkey] = sender_public_key

            # kirim kepada pool
            send_to_pool = `curl -X POST -H "Content-Type: application/json" -d '#{data_to_submit.to_json}' #{MAIN_POOL}/miner/pool/submit `

            # puts "send_to_pool"
            # puts send_to_pool
            # puts data_to_submit.to_json

            obj_send_to_pool = JSON.parse(send_to_pool)

            if obj_send_to_pool["success"] === true
                return hash_string
            else
                return obj_send_to_pool["msg"]
            end
        else
            return is_this_valid_sender_file_address
        end
    end

    # == Kurang
    # 1. Cek apakah private key menghasilkan public key yang ada dalam file
    def self.valid_sender_file_address?(address)
        file_full_path = "#{KEYSTORE_PATH}/#{address}"

        # cek dulu, apakah file address ada pada keystore
        if File.exist?(file_full_path)

            # baca dulu file
            data_text = File.read(file_full_path)

            obj = JSON.parse(data_text)

            # cek apakah public key menghasilkan address yang diminta
            public_key_pem = obj["pubkey"]

            if "Nx#{Digest::SHA1.hexdigest(public_key_pem)}" == obj["address"] && "Nx#{Digest::SHA1.hexdigest(public_key_pem)}" == address
                return true
            else
                return "Fail. Private key file format does not match"
            end
        else
            return "Fail. Private key file does not exist"
        end
    end

    # == Keterangan
    # Retrieving data in the private key file
    def self.sender_key_obj(address)
        data_text = File.read("#{KEYSTORE_PATH}/#{address}")
        return JSON.parse(data_text)
    end

    # == Dipanggil dari
    # Pool.submit
    def self.valid_address?(address)
        if address.length === 42
            return true
        else
            return false
        end
    end

    # == Dipanggil dari
    # Pool.submit
    def self.valid_address_and_pubkey?(address, pubkey)
        if "Nx#{Digest::SHA1.hexdigest(pubkey)}" === address
            return true
        else
            return false
        end
    end
end
