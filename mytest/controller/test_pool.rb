require "test/unit"

require 'openssl'
require 'json'
require 'base64'
require 'mongo'
require 'redis'

ENV = "test"

require_relative "setup_test"

require_relative '../../controller/block'
require_relative '../../controller/blockchain'
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
        # {
        #     "success" : true,
        #     data: {
        #     "hash" : "fe194c2325d62c759ca514742e70a80c58759979a64468c4d09f8fd77b4db468",
        #     "enc" : "ROV9TfBYmB8PDz+sQmkq8ZZzrvjISfBq9pdQ5WjgbHGehptXLIjy7gA1h8PU\nGoJ0ukn2dqE7kOSI9JIG9Yfos41aI3Xnbwi4qSzj6XcF+dilnxElIwctirME\nrEBBYlxntT0kptXLSrrwZAMWu68oaMQY9RP41d7wpqGSHAykmC6cIJOV85kq\nRVaOGcLoB6Os0bpK1HUZlNJryCj0jKdpF9pix9FlW61vVo/F5HU4PI2VvoRK\n0cWddKBa5o1Ha5JJOy0baxPyXAVtGC/ie4riq3v9zB2qP8Mr/oml+6SLGX0/\na6rp9kQJp4SSEYgC7arcNorhngfAuKD5U7XntD78wA==\n",
        #     "sign" : "A3bu5fCOpMXBhKBxWCakIHUbisYluoJuZjvIaPcIx0tHLoZY30aXPrlkWPTo\nSn342z/fQGYAbfhLKlU9jXW7GihfEOYthmfxWyjAKzVLKD/MJU5XS2RoiqgR\nfxToVcQLhVPdym2qc3dtRPXAX5bU9B9u6y0ZziwE3kIbJctRzpN0wZ7HU2Yr\nDi4VfxL8eCyxchYR/Y1oR6muMpvy10MX7O5ogNtqP/qP3K3cEuCNLEIgvCPA\ng36XHUI+m27X6Cq9T3ZRI9D8ovQUVzjZvRNcNU9gisl9WuSp7s/rl/yD6waF\nuSpOUzgFbzo/aGlhXoNKEcMTDzLzI/TiRqNbWHBI4Q==\n",
        #     "pubkey" : "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
        #     "data" : {
        #         "block" : 3,
        #         "from" : "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
        #         "to" : "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
        #         "amount" : 100,
        #         "fee" : 5,
        #         "data" : {},
        #         "time" : 1568933789
        #     }
        # }}
        # yang perlu kita simpan dalam pool hanya properti data
        wallet_transfer = Wallet.transfer('{"block":3,"from":"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096","to":"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f","amount":100,"fee":5,"data":{},"time":1568933789}')

        Pool.add(wallet_transfer[:data].to_json)

        mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        assert_equal(3, mongoclient[:poolouts].find().to_a.count )

        assert_equal(1, mongoclient[:pools].find().to_a.count )

    end
end
