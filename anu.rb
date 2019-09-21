require 'json'
data = {
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

puts data.to_json
