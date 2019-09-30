require 'openssl'
require 'json'
require 'base64'
require 'mongo'

#require_relative "env"

class Wallet

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

    def self.balance(address)

        # cari pada blockchain
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        # get last data
        items = client[:blockchains].find({"data.outputs.address": address}).sort({"data.num": -1}).limit(1).to_a

        if items.size > 0

            # keluarkan dan ambil datanya
            items[0][:data][:outputs].each do |f|
                if f[:address] === address
                    @balance = f[:balance]
                end
            end

            return {success: true, data: {balance: @balance}}
        else
            return {success: true, data: {balance: 0}, msg: "New address or zero balance"}
        end

    end

    # from, to, amount, fee, data
    def self.transfer(data_json)

        socket = TCPSocket.new($root_ip, $root_port)

        @kembalian = ""

        obj = JSON.parse(data_json)

        data = {
            block: obj["block"],
            from: obj["from"],
            to: obj["to"],
            amount: obj["amount"],
            fee: obj["fee"],
            data: obj["data"],
            time: obj["time"]
        }

        main_pubkey_file = "#{MAIN_CONFIG_PATH}/main_pubkey"
        text = data.to_json

        is_this_valid_sender_file_address = Wallet.checking_valid_sender_file_address(data[:from])[:success]

        # cek dulu, apakah sender punya file private key
        if is_this_valid_sender_file_address === true
            mykey_text = File.read("#{KEYSTORE_PATH}/#{data[:from]}")
            mykey_file_obj = JSON.parse(mykey_text)

            my_privkey = OpenSSL::PKey::RSA.new(mykey_file_obj["privkey"])
            signature = Base64.encode64( my_privkey.sign(OpenSSL::Digest::SHA256.new, text) )

            destination_public_key = OpenSSL::PKey::RSA.new(File.read(main_pubkey_file))
            hash_string = Digest::SHA256.hexdigest(text)
            public_encrypt = destination_public_key.public_encrypt(text)
            encrypted_string = Base64.encode64(public_encrypt)

            sender_public_key_obj = Wallet.sender_key_obj(data[:from])
            sender_public_key = sender_public_key_obj["pubkey"]

            data_to_submit = {}
            data_to_submit[:hash] = hash_string
            data_to_submit[:enc] = encrypted_string
            data_to_submit[:sign] = signature
            data_to_submit[:pubkey] = sender_public_key
            data_to_submit[:tx] = data

            if ENV == "production"

                # kirim data
                socket.write({command: "submit_to_pool", data: data_to_submit}.to_json)

                @kembalian = socket.gets # baca response yang didapatkan

            elsif ENV == "development"

                # kirim data
                socket.write({command: "submit_to_pool", data: data_to_submit}.to_json + "\n")

                @kembalian = socket.gets # baca response yang didapatkan

            elsif  ENV == "test"
                @kembalian = '{"success": true}'
            end

            obj_send_to_pool = JSON.parse(@kembalian)

            if obj_send_to_pool["success"] === true

                # simpan dalam pool sendiri (disini jika sudah ada, maka dia tidak akan menyimpan)
                mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
                Pool.add(data_to_submit.to_json)

                return {success: true, msg: "", data: data_to_submit}
            else
                return {success: false, msg: obj_send_to_pool["msg"]}
            end
        else
            @kembalian = '{"success": false, "msg": "File not found"}'
        end

        socket.close

        return @kembalian
    end

    # == Keterangan
    # Retrieving data in the private key file
    def self.sender_key_obj(address)
        data_text = File.read("#{KEYSTORE_PATH}/#{address}")
        return JSON.parse(data_text)
    end

    # HANYA DIGUNAKAN UNTUK VALIDASI SENDER KARENA INI BERBAHAYA JIKA KEY LEAK
    def self.validation_key_and_get_pubkey(address)

        if Wallet.checking_valid_sender_file_address(address)[:success] === true

            if Wallet.checking_valid_sender_file_address(address)[:success] === true

                if Wallet.get_data_key_and_content_validation(address)[:success] === true
                    return {
                        success: true,
                        data: {
                            pubkey: Wallet.get_data_key_and_content_validation(address)[:data][:pubkey]
                        }
                    }
                else
                    return Wallet.get_data_key_and_content_validation(address)
                end
            else
                return Wallet.checking_valid_sender_file_address(address)
            end
        else
            return Wallet.checking_valid_sender_file_address(address)
        end
    end

    # hanya digunakan untuk chek apakah address formatnya valid
    def self.validation_address_format(address)
        if address.length === 42
            return {success: true}
        else
            return {success: false, msg: "invalid address format"}
        end
    end

    def self.checking_pubkey_and_address(pubkey, address)
        if "Nx#{Digest::SHA1.hexdigest(pubkey)}" === address
            return {success: true}
        else
            return {success: false}
        end
    end

    # == Kurang
    # 1. Cek apakah private key menghasilkan public key yang ada dalam file
    def self.checking_valid_sender_file_address(address)
        file_full_path = "#{KEYSTORE_PATH}/#{address}"

        # cek dulu, apakah file address ada pada keystore
        if File.exist?(file_full_path)

            # baca dulu file
            data_text = File.read(file_full_path)

            obj = JSON.parse(data_text)

            # cek apakah public key menghasilkan address yang diminta
            public_key_pem = obj["pubkey"]

            if "Nx#{Digest::SHA1.hexdigest(public_key_pem)}" == obj["address"] && "Nx#{Digest::SHA1.hexdigest(public_key_pem)}" == address
                return {success: true}
            else
                return {success: false, msg: "Fail. Private key file format does not match"}
            end
        else
            return {success: false, msg: "Fail. Private key file does not exist"}
        end
    end

    ##
    # == Keterangan
    # digunakan untuk validasi dan mendapatkan data dari key
    def self.get_data_key_and_content_validation(address)
        file_full_path = "#{KEYSTORE_PATH}/#{address}"

        data_text = File.read(file_full_path)

        obj = JSON.parse(data_text)

        # cek apakah public key menghasilkan address yang diminta
        public_key_pem = obj["pubkey"]

        if "Nx#{Digest::SHA1.hexdigest(public_key_pem)}" == obj["address"] && "Nx#{Digest::SHA1.hexdigest(public_key_pem)}" == address

            return {
                success: true,
                data: {
                    address: obj["address"],
                    pubkey: obj["pubkey"],
                    privkey: obj["privkey"]
                }
            }
        else
            return {success: false, msg: "Fail. Private key file format does not match"}
        end

    end
end
