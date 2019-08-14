require_relative 'wallet'

class Pool

    # == Keterangan
    # pada submit, data yang didapatkan adalah 
    # {"data":{"from":"Nx76bbc1d213ea8b95a696bbbec14cb46191f25929","to":"Nx78c26710996465c0a26d5306859337865393f224","amount":"120","time":1565782559},"hash":"66bf09eb6550219827c6ed8b455905b09da2adb4","enc":"QUTWL7buMVqTF1HYalCX5EySZQgb9pKLT4PyeILOsD47tDZmLCOza3hqZnSR\nrau53jd6dKLmmS3+R23d2YBVnp6lfP3P40Fw9rqlnxvkc3YU9yVdUwyh2rEk\nBXjMwID1dYBhUDSJPiq1tCSv2azguOI6hQ86ZSD9bF4909dfMbRyClqVRsWD\novY5tgoImGWL0L1aTSi5FMKoTOZfHqTFF0SV+e0gMGQ9rs/nBIZ89JPKMKBK\nVM85iebOCkLN7fjM25Sl3GirCSk0i+4W7lMwDvKElqgzfKtwHszAUktiV4MM\ncbPSF4wfN2pU2tCVA4SY1xxMryfsX2cprAP6BtrTEg==\n"}
    def self.submit(data)

        obj = JSON.parse(data)

        # from dan to tidak boleh address yang sama
        if obj["data"]["from"] != obj["data"]["to"]

            # cek dulu, apakah address valid
            if Wallet.valid_address?(obj["data"]["from"]) === true && Wallet.valid_address?(obj["data"]["to"]) === true

                is_this_valid_transaction = Pool.valid_transaction?(obj)

                if is_this_valid_transaction == true 
                    return true
                else
                    return is_this_valid_transaction
                end
            else 
                return "Fail. Address is not valid"    
            end
        else
            return "Fail. From and to can't be the same"
        end
    end

    def self.valid_transaction?(obj)
        if obj["data"]["from"] && obj["data"]["from"] != ""
            if obj["data"]["to"] && obj["data"]["to"] != ""
                if obj["data"]["amount"] && obj["data"]["amount"] != ""
                    if obj["data"]["time"] && obj["data"]["time"] != ""
                        if obj["hash"] && obj["hash"] != ""
                            if obj["enc"] && obj["enc"] != ""

                                # decrypt dulu menggunakan private ke master
                                private_key = OpenSSL::PKey::RSA.new(File.read("#{MAIN_CONFIG_PATH}/main_privkey"))
                                string_decrypt = private_key.private_decrypt(Base64.decode64(obj["enc"]))

                                puts "string_decrypt"
                                puts string_decrypt

                                decrypt_obj = JSON.parse(string_decrypt)

                                if decrypt_obj["from"] == obj["data"]["from"] && decrypt_obj["to"] == obj["data"]["to"] && decrypt_obj["amount"] == obj["data"]["amount"] && decrypt_obj["time"] == obj["data"]["time"]
                                    return true
                                else
                                    return "Fail. Data is not match"
                                end
                            else 
                                return "Fail. Enc required"     
                            end
                        else 
                            return "Fail. Hash required"     
                        end
                    else
                        return "Fail. Time required"     
                    end
                else 
                    return "Fail. Amount required"
                end
            else 
                return "Fail. To required"
            end
        else 
            return "Fail. From required"
        end
    end
end