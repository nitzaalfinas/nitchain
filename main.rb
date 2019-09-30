require 'sinatra'

require 'openssl'
require 'json'
require 'base64'
require 'mongo'
require 'redis'
require "socket"

require_relative 'controller/env'
require_relative 'controller/pub'
require_relative 'controller/wallet'
require_relative 'controller/miner_pool'
require_relative 'controller/miner_mine'
require_relative 'controller/merkle'
require_relative 'controller/block'
require_relative 'controller/blockchain'

$redis = Redis.new(host: "localhost", port: 4011)

$redis.subscribe('pool', 'block') do |on|
    on.message do |channel, msg|
        data = JSON.parse(msg)
        puts "##{channel} - [#{data['user']}]: #{data['msg']}"
    end
end

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

    MinerPool.submit(request.body.read)
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
    if params[:password] === LOCAL_PASS
        Wallet.create
    end
end

# == Params
# from
# to
# amount
# Flowcharts
# https://docs.google.com/drawings/d/1Q7IyBFYjyLAcXWH6LIovDMA_A8Ez8ksjOx8-LOZhUs8/edit?usp=sharing
post '/wallet/transfer' do
    Wallet.transfer(params[:from], params[:to], params[:amount])
end

# == Proses
# dia aktif meminta data kepada node yang ada diluar
get '/blockchain/sync/add' do
    data = '{"hash":"0006aea0806ea0a4f8e30f6c65a3ba2b7bf995085f5e8db6bc8d23b101cfb5fc","data":{"num":3,"prevhash":"000caf794e47a613d9000a4dce1b37ab4894502c9fc218fc49019ab112708601","tcount":1,"tamount":1000000150,"diff":3,"mroot":"1d664bdd0c6e4946e56b3ce46d9f668e49f1a958f45f168af347c457d77022d9","miner":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","reward":50,"txs":["e358ac153c05ddf8842da698e151d1147f895258862f4485cd3644a7378e2027"],"txds":[{"hash":"e358ac153c05ddf8842da698e151d1147f895258862f4485cd3644a7378e2027","from":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","to":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n","sign":"MIuDG8b+T32nFKYBs3HY7UXokuwIQ3PfMduxx5oQATaaxTVnJVP7RXe6Xkhr\nR+SWjQ9yDWxoE9lmaFROHCR6VjfFSM+LtQ9uktRyhCuRLVIGEII4f8RWSgMg\nTVssCCjim8sc8JSHp7V88XOmnwOduCdQQDGvqRDvdHvOJ/Bk4kgycInByEjY\nQQI9vqtRMige+6qbP9eOteRG7rl3/D9v85fCy33bTIANVdibwPQtNd/pwOYE\nnaduWMRNkicdLooUfJsNt4yPSi12MX/mxUpmft3aMw7EB48ePJ9OoJHOcIT+\nLb/Ja6Y9xm1QuOCTxlOscW4C+jfMEyGHQij67DfA3w==\n","tx":{"input":{"from":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":999900100,"to":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","amount":200000},"outputs":[{"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":999700100},{"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":300000}],"time":1567760639}}],"outputs":[{"address":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","balance":999700150},{"address":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","balance":300000}],"time":1567760775,"nonce":7626}}'
    Blockchain.add(data).to_json
end
