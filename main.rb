require 'sinatra'

require 'openssl'
require 'json'
require 'base64'
require 'mongo'

require_relative 'env'
require_relative 'controller/wallet'
require_relative 'controller/pool'

# configure do
#     db = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)  
#     set :mongo_db, db[DATABASE_NAME]
# end

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
        Pool.submit(request.body.read)
    else
        {success: false, msg: 'not a miner' }.to_json 
    end
end

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