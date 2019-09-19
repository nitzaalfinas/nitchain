class SetupTest

    def self.destroy_blockchain_collections
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        client[:blockchains].delete_many()
    end


    def self.seed_blockchains_collections

        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        block_genesis = {
            "hash": "000b25a03fe29683fa84e2b4a9771c7813e44d73001b984b08f9cd580289dbfd",
            "data": {
                "num": 1,
                "prevhash": "",
                "tcount": 1,
                "tamount": 1000000050,
                "diff": 3,
                "mroot": "fca28e46e38245195a286f4f1788046db49564ba203df4eefa823544426b01aa",
                "miner": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                "reward": 50,
                "tfee": 0,
                "txs": [
                    "369a65796e82c2bd89175d7afe0c06dc387ee09c955687acad0b76d0ef17a5d7"
                ],
                "txds": [
                    {
                        "hash": "369a65796e82c2bd89175d7afe0c06dc387ee09c955687acad0b76d0ef17a5d7",
                        "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign": "kcfvCAl8aJs3YFa7fK2BdY2RqpJ9FepcA2s3rfY5/CTWnQBqhnSeT5x90ak7\nswDQZkJdSyhx4In/Ly38ttxrvPESwnYL7Fr2TGTuyW3REdlnzXxefM+f7D87\nmKYl4GlYbfsj4julHMss4McKB6As5ekW24cHVJ1/qSAmzHykHU25K5JuLCk9\nLb6sarbPsWkhEhwnAPLag2b3rm1GmPZbzjB947avulS17ubTfdHtGN5Q1lkG\nLXnSz8szy0NXAaB0y2q6tEQI28NrYDXfzXd5Oc8U7GwF2SIASeaBatfGTcJG\nFQeyqWYHGEOrdaNtgkhjipwHR3HfZZeMvue8YQ2AXA==\n",
                        "tx": {
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
                "time": 1568901319,
                "nonce": 5321
            }
        }

        block_second = {
            "hash": "000a26c655b384a82ada529033aa893c7db0808176affeca42e5a0f4433264d4",
            "data": {
                "num": 2,
                "prevhash": "00042bc278082c550e9a6ad9aa799211145e6c92385a194fb09c5d57f12897d0",
                "tcount": 1,
                "tamount": 1000000100,
                "diff": 3,
                "mroot": "9513b08f0301a13b425d8e9463e4cc5c24a5272a7440291c05cb3623a8a13459",
                "miner": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                "reward": 50,
                "tfee": 5,
                "txs": [
                    "05cb8c45ebbdb4b4cc4af3569e7366711d03cbb209cf860d2bb12845b734d2a1"
                ],
                "txds": [
                    {
                        "hash": "05cb8c45ebbdb4b4cc4af3569e7366711d03cbb209cf860d2bb12845b734d2a1",
                        "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign": "GpUFvFbcXoV3SkvogXhTKnBvWgzPMHF/N49ZWHkdCyL01RVdfu7DslgGrEpJ\nwxqRgQfp0eLuSNiqKLJUodHkTAzeLE7s129AC8Y0Lv82gpgQ1Q2mz8zhYf1e\nI+FhMSbdl3u+p6mOnDke0VdF30dSGtpRSmK2INnSZiF1+AMCcmMdvf77Sxc+\n+s5JsfN8JQD9h7tIL+15juBGugwFexkg+C7u2B+v2YAR5LdCjdookv6HcTgv\ny4nozvLDATkQj9QmTseXrKOfJ2hbGcZ/YSrjQYvqX/LqSfEaTDu9Sq5Mqk0h\nLMIOs7Yxjehg4fCVyqSn4oV98ThyPQvbr04Vdjxokw==\n",
                        "tx": {
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
                        "balance": 1000000105
                    }
                ],
                "time": 1568902856,
                "nonce": 5237
            }
        }

        client[:blockchains].insert_one(block_genesis)

        client[:blockchains].insert_one(block_second)
    end

    def self.destroy_pool_collections
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        client[:pools].delete_many()
    end

    def self.seed_pool_collections
        data = {
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

        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)
        client[:pools].insert_one(data)
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
