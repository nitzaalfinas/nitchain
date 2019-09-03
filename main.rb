require 'sinatra'

require 'openssl'
require 'json'
require 'base64'
require 'mongo'
require 'redis'

require_relative 'env'
require_relative 'controller/wallet'
require_relative 'controller/miner_pool'
require_relative 'controller/miner_mine'

redis = Redis.new(host: "localhost", port: 4011)

get '/' do
    'NitChain'
end

# == Params
# from
# to
# amount
# hash
# pbkey
post '/miner/pool/submit' do
    if MINE === 1
        MinerPool.submit(request.body.read)
    else
        {success: false, msg: 'not a miner' }.to_json
    end
end

get '/miner/mine' do
    MinerMine.mine
end

# dinonaktifkan dulu, sepertinya ketika membuat merkle root harus disertai dengan mine
# get '/miner/mine/create_merkle' do
#     puts "sampai sini"
#     MinerMine.create_merkle
# end

# == Todo
# only who own this server can execute this code
get '/wallet/create' do
    Wallet.create
end

# == Params
# from
# to
# amount
post '/wallet/transfer' do
    Wallet.transfer(params[:from], params[:to], params[:amount])
end


get '/blockchain' do
end
