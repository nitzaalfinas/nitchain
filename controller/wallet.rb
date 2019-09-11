require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative "env"

class Wallet

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
