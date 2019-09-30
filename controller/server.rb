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

                    puts obj["data"]

                    kembali = Pool.add(obj["data"].to_json)
                    puts kembali
                    #client.write(kembali.to_json + "\n") # kirim balasan
                    client.write("anu-anu\n")
                else
                    # method yang lain
                    client.write("anu-anu999\n")
                end

            end
        end
    end
end
