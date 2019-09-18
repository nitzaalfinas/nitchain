class SetupTest

    def self.destroy_blockchain_collections
        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        client[:blockchains].delete_many()
    end

    def self.seed_db

        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)

        block_genesis = {
            "hash": "000041e532fb80cab55811483e5db2933bb315ecacda5cff7892dccde9a05985",
            "data": {
                "num": 1,
                "prevhash": "",
                "tcount": 1,
                "tamount": 1000000050,
                "diff": 3,
                "mroot": "72000f400172a33b7f014d63eb0d0e7a29a787a53f085acbf40163fe028fb077",
                "miner": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                "reward": 50,
                "txs": [
                    "2790af614ddc0b188bd8b7dd8f9c2e4bbf98c6abdb7ef38a9d987c3d8f228bf7"
                ],
                "txds": [
                    {
                        "hash": "2790af614ddc0b188bd8b7dd8f9c2e4bbf98c6abdb7ef38a9d987c3d8f228bf7",
                        "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvwunW9qbYH+KnXpxEu8w\niLiZSN2s1o21z7KG9w8k+xsbTYJ+BfGPEYKnP34eKN+5pp7lo+Uvfd/NIeO2c/gs\nzsc9iZ3mjuJAxdMArirpptac5bdR77/jSmL6hws1uuvaX+SC/5LziwjbSOZn/xl7\nBlsYMRmreVJJyTbBoMeewYXYJ+zBKBsJjo/nHf1cRrlB2nMX1IahW7uE7nJaVT72\nvdCMR1Dq418StJX6hN8qG3xR6f1KWtTHqKl2Ykdi+l6pKYK8GOO+3RpRGadvDluo\nIfcQGdcE3IsRWYwrReMIt/GgjfhxNIi1nac6+ASrNtMv2UAX567h7mMeliJ4fO5j\ngwIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign": "GNrakdr3AbvUfFLn0gmYBD8kAwk7cmjwOXkt3XbhlyS1iYzgDuKG31WMaOaZ\nafgFETIfDG2ixxi5luwbwu6TTVFNUFrWFpGid/6zi88/0tewCqJbyzz2Rf+q\nj0L8X9oPPVo5RHxSF5wQHA04XH4xfYCVABCKf3/zLDtdOLaCd78hxG1KAoDU\nIbZw9M8ENqzKPVAt0zFCEcrgJJTYTfk5GZxZLoE6i3zn0CLdwkToHDiHJVKe\neiPkfQao8Lu0QKfJ5EPqhszNR2GiqJ304aEZuMjF8yPGlGERysYI58kmYnGO\nBXZ36z2BRERsjPcjPYllMrb6xoOaX0mZFEFt8RQXlQ==\n",
                        "tx": {
                            "input": {
                                "genesis": true,
                                "from": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                "balance": 1000000000,
                                "to": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                                "amount": 1000000000,
                                "fee": 0,
                                "data": {}
                            },
                            "outputs": [
                                {
                                    "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                    "balance": 0
                                },
                                {
                                    "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                                    "balance": 1000000000
                                },
                                {
                                    "address": "miner",
                                    "balance": 0
                                }
                            ],
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
                "time": 1567743389,
                "nonce": 6320
            }
        }

        block_second = {
            "hash": "0002aab859017d41b67d9c2b14acb3cc264fbbf5ff3bb71b6e1f92826c6a237b",
            "data": {
                "num": 2,
                "prevhash": "000041e532fb80cab55811483e5db2933bb315ecacda5cff7892dccde9a05985",
                "tcount": 1,
                "tamount": 1000000100,
                "diff": 3,
                "mroot": "ec0dbe032e88fa0f64b103453419d62d29e4ecbef27d7e983764df51bf5ad3ee",
                "miner": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                "reward": 50,
                "txs": [
                    "4e90136b21c89e24bc9fe65eaa2dfe071e38a719201ef88f49d714609c4d949f"
                ],
                "txds": [
                    {
                        "hash": "4e90136b21c89e24bc9fe65eaa2dfe071e38a719201ef88f49d714609c4d949f",
                        "pubkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
                        "sign": "TeOANnD6AuZHpT+R35OZxbE1LR7/vVkjwM3kmU8ezefOGqFkRgwJofSXtwYx\nSwToCJmgRtm/qwcIrU0Rqoln3yxG4L2WXG/Kxszdp8zdRkHRydrA5rtbo0m8\nYPtOaFGCXcg7AtsxE2VclnGPhyIAow0kmOw/3ola/ZpdOClS6mw7P0eTSAcQ\n/gqV/R+p7Ceq7cYCBVohBjUVWIYar+iAGNeYqmTJSftc9EuK8fD9Odc4prHW\nLPqoVulwdkZDmrYNpHgT/27xQNZE53la+AeEIq1WZuCgENk1G0rV7qSgqT3Q\nvE1Vg3ujY0qRICfFIS7y1Z6/ZYB9Ba97i3LCguvUDQ==\n",
                        "tx": {
                            "input": {
                                "from": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                                "balance": 1000000050,
                                "to": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                "amount": 45,
                                "fee": 5,
                                "data": {}
                            },
                            "outputs": [
                                {
                                    "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                                    "balance": 1000000000
                                },
                                {
                                    "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                                    "balance": 45
                                },
                                {
                                    "address": "miner",
                                    "balance": 5
                                }
                            ],
                            "time": 1568688154
                        }
                    }
                ],
                "outputs": [
                    {
                        "address": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "balance": 1000000055
                    },
                    {
                        "address": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
                        "balance": 45
                    }
                ],
                "time": 1567760775,
                "nonce": 5144
            }
        }

        client[:blockchains].insert_one(block_genesis)

        client[:blockchains].insert_one(block_second)
    end

    def self.block_three
        data = {
            "hash": "0007370d8df20a39fef8f62e54a864b8b2106b593a9cbd248a68ad6999e8b47c",
            "data": {
                "num": 3,
                "prevhash": "0002aab859017d41b67d9c2b14acb3cc264fbbf5ff3bb71b6e1f92826c6a237b",
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
                        "from": "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
                        "to": "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
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
                "nonce": 282
            }
        }

        return data
    end
end
