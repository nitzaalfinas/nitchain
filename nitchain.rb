require 'socket'
require 'optparse'

ENV = "development"

#require_relative 'controller/env'
require_relative 'controller/wallet'
require_relative 'controller/merkle'
require_relative 'controller/block'
require_relative 'controller/blockchain'
require_relative 'controller/server'
require_relative 'controller/pool'

options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: main.rb [options]"

    opts.on("--command [STRING]") do |j|
        options[:command] = j
    end

    opts.on("--data [UNAME]") do |j|
        options[:data] = j
    end

end.parse!

# debug saja
#p options

# ruby nitchain.rb --command wallet_create
if options[:command] == 'wallet_create'
    # buat wallet sekalian berikan return
    puts Wallet.create

# ruby nitchain.rb --command wallet_transfer --data '{"block":3,"from":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","to":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","amount":100,"fee":5,"data":{},"time":1568933789}'
elsif options[:command] == 'wallet_transfer'
    puts Wallet.transfer(options[:data])

# ruby main.rb --command server_listen
elsif options[:command] == 'server_listen'
    Server.listen

else
    puts ""
    socket = TCPSocket.new('localhost', 3000)

    # kirim data
    socket.write("#{ARGV[0]}\n")

    puts socket.gets # baca response yang didapatkan
    socket.close
end
