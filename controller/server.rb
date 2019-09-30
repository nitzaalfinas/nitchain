class Server

    def self.listen
        server = TCPServer.new('localhost', 3000)

        $stdout.sync = true

        loop do
            client = server.accept

            until client.eof?

                # data yang dilewatkan adalah hanya 1 baris saja dan berupa string
                # maka disini diambil dan dibuat object nya
                msg = client.gets
                obj = JSON.parse(msg)

                # masukkan data kedalam pool
                if obj["command"] === "submit_to_pool"
                    puts "----- submit_to_pool -----"

                    kembali = Pool.add(obj["data"].to_json)
                    #puts kembali
                    client.write(kembali.to_json + "\n") # kirim balasan
                elsif obj["command"] === "sync_ask_block"

                    puts "----- sync_ask_block -----"

                    block = Blockchain.get_block_by_number(obj["data"])

                    if block

                        block.delete("_id")

                        kembali = {
                            success: true,
                            data: block
                        }

                        client.write(kembali.to_json + "\n")
                    else
                        client.write({success:false, msg: "No block"}.to_json + "\n")
                    end

                elsif obj["command"] === "broadcast_new_block"

                    puts "----- broadcast_new_block -----"

                    block = Blockchain.add_incoming_block(obj["data"].to_json)

                    if block[:success] === true

                        kembali = {
                            success: true,
                            data: block
                        }

                        client.write(kembali.to_json + "\n")
                    else
                        client.write({success:false, msg: "No block"}.to_json + "\n")
                    end

                else
                    # method yang lain
                    client.write("anu-anu999\n")
                end

            end
        end
    end
end
