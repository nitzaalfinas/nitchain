require 'openssl'
require 'json'
require 'base64'
require_relative 'genesis_key'


keyobj = JSON.parse(@keyjson)

zz = {}

zz[:input] = {}
zz[:input][:genesis] = true
zz[:input][:from] = "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f"
zz[:input][:balance] = 1000000000
zz[:input][:to] = "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096"
zz[:input][:amount] = 1000000000
zz[:input][:fee] = 0
zz[:input][:data] = {}

zz[:outputs] = []
zz[:outputs][0] = {}
zz[:outputs][0][:address] = "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f"
zz[:outputs][0][:balance] = 0
zz[:outputs][1] = {}
zz[:outputs][1][:address] = "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096"
zz[:outputs][1][:balance] = 1000000000
zz[:outputs][2] = {}
zz[:outputs][2][:address] = "miner"
zz[:outputs][2][:balance] = 0


# kunci pada date time ini
zz[:time] = 1567676889

puts "tx ===="
puts zz.to_json

thehash = Digest::SHA256.hexdigest(zz.to_json)

puts ""
puts "hash"
puts thehash

my_privkey = OpenSSL::PKey::RSA.new(keyobj["privkey"])
signature = Base64.encode64( my_privkey.sign(OpenSSL::Digest::SHA256.new, zz.to_json) )

puts ""
puts "signature"
puts signature


storedata = {}
storedata[:hash] = thehash
storedata[:pubkey] = keyobj["pubkey"]
storedata[:sign] = signature
storedata[:tx] = zz


puts ""
puts ">>> simpan dalam transactions"
puts storedata.to_json


# 1. dari sini kebawah adalah membuat blockchain

# 1.1. Membuat merkle tree dan merkle root terlebih dahulu
merkle_root_hash = Digest::SHA256.hexdigest(thehash + thehash)

puts ""
puts "merkle_root_hash"
puts merkle_root_hash

# 1.2. Membuat block data
block = {}

block[:data] = {}
block[:data][:num] = 1
block[:data][:prevhash] = ""
block[:data][:tcount] = 1
block[:data][:tamount] = 1000000050
block[:data][:diff] = 3
block[:data][:mroot] = merkle_root_hash
block[:data][:miner] = zz[:input][:to]
block[:data][:reward] = 50
block[:data][:txs] = [thehash]
block[:data][:txds] = []
block[:data][:txds][0] = storedata

block[:data][:outputs] = []
block[:data][:outputs][0] = {}
block[:data][:outputs][0][:address] = zz[:input][:from]
block[:data][:outputs][0][:balance] = 0
block[:data][:outputs][1] = {}
block[:data][:outputs][1][:address] = zz[:input][:to]
block[:data][:outputs][1][:balance] = 1000000050


# 1.3. Mine!
minehash = ""
nonce = 0
loop do
    #block[:time] = Time.now.utc.to_i # ini harus selalu diatas nonce
    block[:data][:time] = 1567743389
    block[:data][:nonce] = nonce
    minehash = Digest::SHA256.hexdigest(block[:data].to_json)

    nonce = nonce + 1

    # find leading zero
    if minehash[0..(block[:data][:diff]-1)] == "0" * block[:data][:diff]
        break
    end
end

puts ""
puts ">>> simpan dalam blockchains[0] data"
akhir = {
    hash: minehash,
    data: block[:data]
}
puts akhir.to_json
