require "test/unit"

require 'openssl'
require 'json'
require 'base64'
require 'mongo'
require 'redis'

ENV = "test"

require_relative "setup_test"

require_relative '../../controller/block'
require_relative '../../controller/merkle'
require_relative '../../controller/transaction'
require_relative '../../controller/wallet'
require_relative '../../controller/pool'

class TestPool < Test::Unit::TestCase

    # sekarang adalah block nomor 2
    # test akan kita buat pada block nomor 3
    test "def self.add berhasil karena data belum ada, balance cukup" do
        # hapus semua yang ada pada blockchains
        SetupTest.destroy_blockchain_collections

        # hapus semua yang ada pada pools
        SetupTest.destroy_pool_collections

        # masukkan data block 1 dan 2
        SetupTest.seed_blockchains_collections

        # kirim 1 transaksi kedalam pool
        # data yang dikirim ke pool akan memberikan return seperti ini
        # {:success=>true, :msg=>"", :data=>{:hash=>"13e7449cfdb44bff6173e17328075aa3f05ca60b5413d1ca86d462c1ea6fa673", :enc=>"gmQsSUeZdpR8olKdQZ1M8gNLR4q6pq4iHwd4aw+GVVUlkZ014rNyHCt6zkSz\npZ7XnoRdAXzjkWr3un3/pXRKG/qjkwBS2UgUJXxST/Ga9fvDjLbfe/7vB89H\n12P+zJYNW5K+igIfOqIVexnTzLnz9u+d0Rm33fVb25lvFQCQ2ARvr3W6vyDf\nNZ6wn9Mq4s5kuQTVBv2MYuFDInHf5PYxS+/z2kWnwGKWmKNXgiPKPt+5JA45\nTAZ1HNGIZQQR4oeS0pdL8nvQk+hSunTH1/1jZ4eZXku2au/kfGm9515Zoeki\n0sPOeYmBMjiVUa9rBAYyIQykDgAbTZ5l6tbZXeFsyg==\n", :sign=>"A8IW5LLYco/XTSOCnSTJOGzJmu1NRufjvE74Yoq74Yh3K4KAULWbtwdOan1N\nhXryGO8o5U5rhx8IKkBP30NzHjmgkP3z5pQPqnNiIe1Q3ufeoSyv9nApamZY\n9eMeBGnu+byzD/veLvDh/zUeo+XgWMe7l/Qv9XynKoNtBMNbprOlitSbzAHF\nKZgpTY7JPyvfNslNocGUXuG5AUQwYKFn4Ik8vGe0ywhQwibCDQOyV1Ntb072\nSLrsDruZD5ukc4sbPBtxP6mycbDkOcDOpONc8PoiaAWQoFQ+yo+Rzt+67oCb\nGWjjCNn0rYFZwmhsc55FHLykE29hTBrngL8UUSf9ig==\n", :pubkey=>"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n", :data=>{:from=>"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096", :to=>"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f", :amount=>100, :fee=>5, :data=>{}, :time=>1568933789}}}
        # yang perlu kita simpan dalam pool hanya properti data
        wallet_transfer = Wallet.transfer('{"from":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","to":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","amount":100,"fee":5,"data":{},"time":1568933789}')

        Pool.add(wallet_transfer[:data].to_json)

        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        assert_equal(2, mongoclient[:poolouts].find().to_a.count )

        assert_equal(1, mongoclient[:pools].find().to_a.count )

    end
end
