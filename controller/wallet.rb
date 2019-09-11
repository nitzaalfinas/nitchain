require_relative "env"

class Wallet

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

        puts file_full_path

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

    private

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
            return {success: true, data: {address: obj["address"], pubkey: obj["pubkey"], privkey: obj["privkey"]}}
        else
            return {success: false, msg: "Fail. Private key file format does not match"}
        end

    end
end
