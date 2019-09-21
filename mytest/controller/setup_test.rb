class SetupTest

    def self.destroy_blockchain_collections
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        client[:blockchains].delete_many()
    end


    def self.seed_blockchains_collections

        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        block_genesis = {
            "hash": "00006f331df1d08034b22489829c784d1c45be2c37813f8ed37a433de9a09566",
            "data": {
                "num": 1,
                "prevhash": "",
                "tcount": 1,
                "tamount": 1000000050,
                "diff": 3,
                "mroot": "0730acf829510535b17a197a7e1f749157b19e59fbee68df6741991a03e6f3c9",
                "miner": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                "reward": 50,
                "tfee": 0,
                "txs": [
                    "a3de365c86430d86f0ff2a0d126024026c0669dabf53957f99b0e0a7046276ee"
                ],
                "txds": [
                    {
                        "hash": "a3de365c86430d86f0ff2a0d126024026c0669dabf53957f99b0e0a7046276ee",
                        "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign": "I+WWwxBoJrwDdCiX2LYevo1xciUmUCXlz2bYz1yzj4j69ftApMjakl/PSY1L\nPMIqyUb3qnUuwOn+ALb+7e3ip+UEWq3vtwGV9nn1lCaEzfdEaaAqAovKHZwz\nXSTW1JBp8r5KzWGuezMmgJCjZHM1yvO/2NOxWe3I2l1BZwluoUx1PNkMt5Nh\nWdzjGx2oL5kffBMNB+Zzn2N/ejYx00dzcanJ6x9UPFq6Wh9xp87vEU51IvyH\n2aOeOaa7KSKe24TbuITVqteBPh+vvOz2CPoQEYkZD5lVkNhgvACG5B0fz524\n9KXumni5aOUB9ZOH2zMBhF2AUb3LHPdodVxdrRtmmA==\n",
                        "tx": {
                            "block": 1,
                            "from": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                            "to": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                            "amount": 1000000000,
                            "fee": 0,
                            "data": {},
                            "time": 1567676889
                        }
                    }
                ],
                "outputs": [
                    {
                        "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "balance": 0
                    },
                    {
                        "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "balance": 1000000050
                    }
                ],
                "time": 1569022753,
                "nonce": 386
            }
        }

        block_second = {
            "hash": "000bfd1459664a93a5e6544c8b496b779b1c61017787331002fed012dbb0e9bf",
            "data": {
                "num": 2,
                "prevhash": "00006f331df1d08034b22489829c784d1c45be2c37813f8ed37a433de9a09566",
                "tcount": 1,
                "tamount": 1000000100,
                "diff": 3,
                "mroot": "1e1db092ecb8a60fbdbb85ec6085858d74b362ef6d2b1f2ce15fe3eaa88c48ea",
                "miner": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                "reward": 50,
                "tfee": 5,
                "txs": [
                    "ce42461efce9b8b44a30f3b0b4fea6f5322de81700baefa2d1229e90b9ee5d49"
                ],
                "txds": [
                    {
                        "hash": "ce42461efce9b8b44a30f3b0b4fea6f5322de81700baefa2d1229e90b9ee5d49",
                        "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign": "fFszEMzH5T3xOjStOI5HZmSY/1B44C4vX786Ga/3g6gNmkY7XSECMcoS8gfe\n7gMht//+tzzuPeg+cM2VcXo55zZGZmAooLYM89LDrvSdN4KOcwv7aU0/Vyiq\nYiey667pVFYfKUl4UlbLesuKMkYWLx3m6plfAJJS8zS9SZhlBYK2zZqzOter\ncHY2U6uwoijPyF5aKBJsEoPdnrPj0zGkBBVn+EXJyY8hayzIGUpW34DdUiiA\ngtJlT9c33Lk6M7loPFQrGByX1icymx0+HHyofa3OoEFjii3Df2pUApHYMQkg\nwkrCAi7JOZ0vt67rI2SWKnvdqftCEAGX7Xg2/1ccuw==\n",
                        "tx": {
                            "block": 2,
                            "from": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                            "to": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                            "amount": 95,
                            "fee": 5,
                            "data": {},
                            "time": 1568901661
                        }
                    }
                ],
                "outputs": [
                    {
                        "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "balance": 95
                    },
                    {
                        "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "balance": 1000000005
                    }
                ],
                "time": 1569022880,
                "nonce": 1466
            }
        }

        client[:blockchains].insert_one(block_genesis)

        client[:blockchains].insert_one(block_second)
    end

    def self.destroy_pool_collections
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        client[:pools].delete_many()
        client[:poolouts].delete_many()
    end

    def self.seed_pool_collections

        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        data_pool = {
            :hash=>"fe194c2325d62c759ca514742e70a80c58759979a64468c4d09f8fd77b4db468",
            :enc=>"Kb9Xn7XVHf1TXXZGEx1eKTNwCHGv9vyZhIs9y7KzhH9CiuRa8IO6eXLMfZd7\nYUTqYLbqM4FzQUMxkn34gCRsLVy8T11rQYklgXXrNL9RnJYbQ/1GwLb82pmr\nPivY1TY5Nu8Ro3MHroZTXbp0gfM03SMHCAoNlEikRMNOAOTgsp0cZ534wYaq\nMCVebM345AylP8FDU91x83gjtcBaAhNb9QKHtyN8f84oofFGol1GrWrWwBdo\noxTKP7rDAR5E8mAzcUuHNNuQuzxhvu0HwkciBqm+ikAerPF8rZ+cqr6zTXky\nSSjGautdKpdXl0ntZ8KrP95dKbtXzChpb5V09KFRQw==\n",
            :sign=>"A3bu5fCOpMXBhKBxWCakIHUbisYluoJuZjvIaPcIx0tHLoZY30aXPrlkWPTo\nSn342z/fQGYAbfhLKlU9jXW7GihfEOYthmfxWyjAKzVLKD/MJU5XS2RoiqgR\nfxToVcQLhVPdym2qc3dtRPXAX5bU9B9u6y0ZziwE3kIbJctRzpN0wZ7HU2Yr\nDi4VfxL8eCyxchYR/Y1oR6muMpvy10MX7O5ogNtqP/qP3K3cEuCNLEIgvCPA\ng36XHUI+m27X6Cq9T3ZRI9D8ovQUVzjZvRNcNU9gisl9WuSp7s/rl/yD6waF\nuSpOUzgFbzo/aGlhXoNKEcMTDzLzI/TiRqNbWHBI4Q==\n",
            :pubkey=>"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
            :tx=>{
                :block=>3,
                :from=>"Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                :to=>"Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                :amount=>100,
                :fee=>5,
                :data=>{},
                :time=>1568933789
            }
        }

        client[:pools].insert_one(data_pool)

        data_poolouts = [
            {address: "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096", balance: 999999900},
            {address: "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f", balance: 195},
            {address: "miner", balance: 5}
        ]

        client[:poolouts].insert_one(data_poolouts[0])
        client[:poolouts].insert_one(data_poolouts[1])
        client[:poolouts].insert_one(data_poolouts[2])
    end

    def self.block_three
        data = {
            "hash": "000e23cc0dda29a5e7000a7669981ec2698e6b13946d594c525300c5a3cd4482",
            "data": {
                "num": 3,
                "prevhash": "000111b142250f0275bd2e18549b358d957837f96d63883fec22458228adfbcd",
                "tcount": 1,
                "tamount": 1000000150,
                "diff": 3,
                "mroot": "ac8addc0665dfa7fc06c0b5a4daec06a2834be9d766623d85fff395d91e3119e",
                "miner": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                "reward": 50,
                "txs": [
                    "4baf6c21c4611822971ee5c7354f3979cdb4c13b1a8972fefd04b4e0aa839730"
                ],
                "txds": [
                    {
                        "hash": "4baf6c21c4611822971ee5c7354f3979cdb4c13b1a8972fefd04b4e0aa839730",
                        "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign": "dV+b+7gArDPoadFe1PZv3CjOCgyhBGNoBr6N8qFcLrZsDIMuR3z/qM1xKDiS\nbvOeeRgtKjeKpkg55nvoctCoilpTuccEV6BHSsQuQB6zDiUb601p/L0JfJhK\nWj7eUQejYj+nnPAZNzG39o362pjWmqscgT15Az1avVji0Fz4AL+kAuRt5h4d\nIejBO61CtcjCO72VFMJqmmTYvpYUSojOJ5oN0WJ/r5mdbMVmpiD4ORh2z9BA\nONgy1tlVH4r/fnDfKmfoTW7rkYdM/sqVSyHmsNK+NpX5OsfqcMz3B9TLMyjC\niYdhwJMKZ/2jkEaIa/VUZSCBj0w7qEe3yZfF/kKyoA==\n",
                        "tx": {
                            "input": {
                                "from": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                                "balance": 1000000055,
                                "to": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                "amount": 95,
                                "fee": 5,
                                "data": {}
                            },
                            "outputs": [
                                {
                                    "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                                    "balance": 999999955
                                },
                                {
                                    "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                    "balance": 140
                                },
                                {
                                    "address": "miner",
                                    "balance": 5
                                }
                            ],
                            "time": 1568695754
                        }
                    }
                ],
                "outputs": [
                    {
                        "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "balance": 1000000010
                    },
                    {
                        "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "balance": 140
                    }
                ],
                "time": 1567761135,
                "nonce": 412
            }
        }

        return data
    end
end
