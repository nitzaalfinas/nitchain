class Transaction

    ##
    # == Params
    # txdata = data for a transaction form key-value hash class
    # == Data structure
    # {
    #     "hash" : "9c81dff5bcdc7909b7e3f042280583e36ab8073e3146ae70046b6f338a6dbb7a",
    #     "from" : "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #     "to" : "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #     "pubkey" : "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwylo6ELYbXFVPmveYEsa\nBvHx3dPpFWmubdlMqFLAVluDY/+maG8CsXFO3GDTAK7z8qj8ZggOIWAhWW0VkDWl\ntbkZezfvloQnbV9lwMncCEQX2YEAK0cl8JmUTXmDkeeRBGZNj7VHa+/6uMv0HZGm\ns5sKr51TGIoxlnH4s8jLkd83mUcLQz+9/MXdMMS8lcNengk7ZTs/xA+PgRozf/yV\n/hc8Qf6DdMxYYmg4rEgZjuO1TghJ9o5QJXYUYZDr40he39ZUJDw/11PKnQQcJNaO\ncv+iQfTtFAGHHo/eBFFzjNccYm8/ojnGGGORlYzH9OXiA4wVG0Z/BNdtl5Wi/xvP\nLQIDAQAB\n-----END PUBLIC KEY-----\n",
    #     "sign" : "CeTOJSk3tCqwFTza+a9YEhaaJ9yIN/HVhdy/GmMONMg1CiN7yVggsviGo+t1\n2sK1G7dW4siCloJJIjHJbvvrmAeeI+UvK3YkWdAFbPd3uDEhj2zIAPnvMWIJ\n7/RoAYmGJtItiAn9Qznb17tAzEpg28JCMXNulzgdbdfYfB9lau241UPjzwUC\nubWhp9t/u3PAXgVmLuXhD2+JvGOaty4aKX2B/jkuY549/N2lbO2rM31CtNtN\nyBqtrUPUCyMadguueo+k6KxMfQaowb8Jwulc79GaIJzVOjHuFPBpFPRuwTQT\n1d+xnvxlt8jl+Zn0HMxCSr0Ctkr/taktqaGtatOUew==\n",
    #     "tx" : {
    #         "input" : {
    #             "from" : "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #             "balance" : 1000000050,
    #             "to" : "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #             "amount" : 100000
    #         },
    #         "outputs" : [
    #             {
    #                 "address" : "Nxf154127e23cde0c8ecbaa8b943aff970c60c590f",
    #                 "balance" : 999900050
    #             },
    #             {
    #                 "address" : "Nxf9c62974d550c1f12cd7d6b9913b44983cb3a096",
    #                 "balance" : 100000
    #             }
    #         ],
    #         "time" : 1567752548
    #     }
    # }
    def self.validation(txdata)

    end

end
