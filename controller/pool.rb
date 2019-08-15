class Pool

    # == Keterangan
    # pada submit, data yang didapatkan adalah 
    # {
    #     "data":{
    #         "from":"Nx3476e5c2b698c4746bc184f96b47815baa352cc3",
    #         "to":"Nx6a578ada9acd3eec09bd695e1b213c0671887c4e",
    #         "amount":"120",
    #         "time":1565822616
    #     },
    #     "hash":"5a8560f081098191ea5baa50d51e0ef7270fecb6",
    #     "enc":"XTBuRMxEROQwHnBPXL9uu6zj5PEr2sger+aPm2IUH1HOKbbMRLVxjemntxab\nQubvyXGJqGOV53ZYu43nTCM1GJf2m6DQX8uo+tJcS3kRR42QYnco5r/uzpGl\ndVmRB3ANsOSpvdYxrc9rMTZ7mJk76Gm4wCW5Dcr5pqHgxI3kByJZPewDmITZ\n7Rq8A8T/Q2m7rk/My2BxFEULFir9a7Soo4x7tBad/k5e+0IxYELI/uBBQusk\nmbcoM52rqem4vHVtGxISYTkziLVSfyD8g3+AHuVnVdXGCPjWOgJc7DKlZFYb\nbpn+zy/puRQHj1N2HhxIGhdUj+iS7hw14As96xlHyQ==\n",
    #     "sign":"go2WCLlUgI2qQvs6T5mN2/XbF/VOeUNSu0IDsq1RlvMMDo3SFFGn64RqPEOF\nPEPLKqXk54Bg5qfXRtzF78ha4OvSagfNABpdcHa6HTbnZzq+OCoJl/PqfJb9\nrRuXfjQjLsgBv89KWgYkOs27wJ6n6hsDTtlIGzsrXVm4Wpx/Jt52umwXIaEi\ncVVULKZIfsN6KsVdvcm3f9wxEj3ZAjNDrax6UiC3pWFSiEUfAbG2Qvd9JT5G\nPlBwXN0dmxgeG4vG5v4rL91r9QfOTqtX/weten+ZCp1TVgcETbEKi/vWOuSR\nGv2XXDsAHsspLha1VnFG+F9MXtPXpDNpXbJP1jOWwA==\n",
    #     "pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApja+JB+2SKRyGvRszoTM\ndjiKVgMfSZL7drHFJQ+CoD0wzthEPawWRWHEhdkGzZWGyXGX07X5g9dKBRFWCqVA\nqXxH6T940hE6A+0baXAltJLsAkno70gCj6tAfWneEKmwhN6/lAthn3dyucH3EXTY\no12uCw9k6r3LHnVQI/7QnakjI9sDQPXTjVSDk+ILUcBG3Numy1o4o8onJ0LsqvGC\nEkPi/xr0lRwSr/UX/D7pcW8UxGl63rcvje/cEvE/06gMvFKKP29/nFXXmDm6u3Vc\nnmHwUccjTthQiGVBHELKbPl7OPZM02jBMF1Aria4mNRktJMLRiCawM5FDeSw/fqo\nxwIDAQAB\n-----END PUBLIC KEY-----\n"
    # }
    def self.submit(data)

        obj = JSON.parse(data)

        # from dan to tidak boleh address yang sama
        if obj["data"]["from"] != obj["data"]["to"]

            # cek dulu, apakah address valid
            if Wallet.valid_address?(obj["data"]["from"]) === true && Wallet.valid_address?(obj["data"]["to"]) === true

                if Wallet.valid_address_and_pubkey?(obj["data"]["from"], obj["pubkey"]) === true 
                    if Pool.valid_transaction?(obj) === true 
                        return {success: true, data: obj["hash"]}.to_json
                    else
                        return {success: fail, msg: Pool.valid_transaction?(obj) }.to_json
                    end
                else 
                    return {success: fail, msg: "Fail. Not public key and address not match!" }.to_json
                end
            else 
                return {success: fail, msg: "Fail. Address is not valid" }.to_json
            end
        else
            return {success: fail, msg: "Fail. From and to can't be the same" }.to_json
        end
    end

    def self.valid_transaction?(obj)
        if obj["data"]["from"] && obj["data"]["from"] != ""
            if obj["data"]["to"] && obj["data"]["to"] != ""
                if obj["data"]["amount"] && obj["data"]["amount"] != ""
                    if obj["data"]["time"] && obj["data"]["time"] != ""
                        if obj["hash"] && obj["hash"] != ""
                            if obj["enc"] && obj["enc"] != ""
                                if obj["sign"] && obj["sign"] != ""
                                    if obj["pubkey"] && obj["pubkey"] != ""

                                        # decrypt dulu menggunakan private ke master
                                        private_key = OpenSSL::PKey::RSA.new(File.read("#{MAIN_CONFIG_PATH}/main_privkey"))
                                        string_decrypt = private_key.private_decrypt(Base64.decode64(obj["enc"]))

                                        decrypt_obj = JSON.parse(string_decrypt)

                                        # periksa pesan decrypt
                                        if decrypt_obj["from"] == obj["data"]["from"] && decrypt_obj["to"] == obj["data"]["to"] && decrypt_obj["amount"] == obj["data"]["amount"] && decrypt_obj["time"] == obj["data"]["time"]

                                            # periksa signature menggunakan sender public key, apakah benar
                                            sender_public_key = OpenSSL::PKey::RSA.new(obj["pubkey"])
                                            if sender_public_key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(obj["sign"]), string_decrypt) === true
                                                
                                                Mongo::Logger.logger.level = ::Logger::FATAL

                                                client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)  
                                                if client[:pools].insert_one(obj)
                                                    client.close
                                                    return true
                                                else 
                                                    return "ErrDB Pool"
                                                end
                                            else 
                                                return "Signature is not match"
                                            end
                                        else
                                            return "Data is not match"
                                        end
                                    else 
                                        return "Sender public key required"     
                                    end
                                else 
                                    return "Signature required"     
                                end
                            else 
                                return "Enc required"     
                            end
                        else 
                            return "Hash required"     
                        end
                    else
                        return "Time required"     
                    end
                else 
                    return "Amount required"
                end
            else 
                return "To required"
            end
        else 
            return "From required"
        end
    end
end