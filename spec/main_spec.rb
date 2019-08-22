require File.expand_path '../spec_helper.rb', __FILE__

describe "NitChain application" do

    MINE = 0
    KEYSTORE_PATH    = "/Users/nitzaalfinas/Documents/app_group/blockchain/nitchain_user/data_rtest/user/keystore"
    MAIN_CONFIG_PATH = "/Users/nitzaalfinas/Documents/app_group/blockchain/nitchain_user/data_rtest/config"
    MAIN_POOL = 'http://localhost:4568'
    DATABASE_NAME = 'nitchain_test'

    # it 'should get /' do
    #     get '/'

    #     puts last_response

    #     expect(last_response).to be_ok
    # end

    # it 'should create a wallet' do
    #     get '/wallet/create'

    #     puts last_response.body

    #     expect(last_response).to be_ok
    # end

    # # post /miner/pool/submit
    # it 'membuat valid data dan diterima oleh miner pool' do
    #     MINE = 1
    #     json_payload = '{
    #             "data":{
    #                 "from":"Nx3476e5c2b698c4746bc184f96b47815baa352cc3",
    #                 "to":"Nx6a578ada9acd3eec09bd695e1b213c0671887c4e",
    #                 "amount":"120",
    #                 "time":1565822616
    #             },
    #             "hash":"5a8560f081098191ea5baa50d51e0ef7270fecb6",
    #             "enc":"XTBuRMxEROQwHnBPXL9uu6zj5PEr2sger+aPm2IUH1HOKbbMRLVxjemntxab\nQubvyXGJqGOV53ZYu43nTCM1GJf2m6DQX8uo+tJcS3kRR42QYnco5r/uzpGl\ndVmRB3ANsOSpvdYxrc9rMTZ7mJk76Gm4wCW5Dcr5pqHgxI3kByJZPewDmITZ\n7Rq8A8T/Q2m7rk/My2BxFEULFir9a7Soo4x7tBad/k5e+0IxYELI/uBBQusk\nmbcoM52rqem4vHVtGxISYTkziLVSfyD8g3+AHuVnVdXGCPjWOgJc7DKlZFYb\nbpn+zy/puRQHj1N2HhxIGhdUj+iS7hw14As96xlHyQ==\n",
    #             "sign":"go2WCLlUgI2qQvs6T5mN2/XbF/VOeUNSu0IDsq1RlvMMDo3SFFGn64RqPEOF\nPEPLKqXk54Bg5qfXRtzF78ha4OvSagfNABpdcHa6HTbnZzq+OCoJl/PqfJb9\nrRuXfjQjLsgBv89KWgYkOs27wJ6n6hsDTtlIGzsrXVm4Wpx/Jt52umwXIaEi\ncVVULKZIfsN6KsVdvcm3f9wxEj3ZAjNDrax6UiC3pWFSiEUfAbG2Qvd9JT5G\nPlBwXN0dmxgeG4vG5v4rL91r9QfOTqtX/weten+ZCp1TVgcETbEKi/vWOuSR\nGv2XXDsAHsspLha1VnFG+F9MXtPXpDNpXbJP1jOWwA==\n",
    #             "pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApja+JB+2SKRyGvRszoTM\ndjiKVgMfSZL7drHFJQ+CoD0wzthEPawWRWHEhdkGzZWGyXGX07X5g9dKBRFWCqVA\nqXxH6T940hE6A+0baXAltJLsAkno70gCj6tAfWneEKmwhN6/lAthn3dyucH3EXTY\no12uCw9k6r3LHnVQI/7QnakjI9sDQPXTjVSDk+ILUcBG3Numy1o4o8onJ0LsqvGC\nEkPi/xr0lRwSr/UX/D7pcW8UxGl63rcvje/cEvE/06gMvFKKP29/nFXXmDm6u3Vc\nnmHwUccjTthQiGVBHELKbPl7OPZM02jBMF1Aria4mNRktJMLRiCawM5FDeSw/fqo\nxwIDAQAB\n-----END PUBLIC KEY-----\n"
    #         }'

    #     post '/miner/pool/submit', json_payload, {format: 'json'}

    #     puts last_response.body
    # end

    # # post /miner/pool/submit
    # it 'tidak bisa masuk kedalam pool masih ada data yang sama dalam pool (from, to, amount)' do
    #     MINE = 1
    #     json_payload = '{
    #             "data":{
    #                 "from":"Nx3476e5c2b698c4746bc184f96b47815baa352cc3",
    #                 "to":"Nx6a578ada9acd3eec09bd695e1b213c0671887c4e",
    #                 "amount":"120",
    #                 "time":1565822616
    #             },
    #             "hash":"5a8560f081098191ea5baa50d51e0ef7270fecb6",
    #             "enc":"XTBuRMxEROQwHnBPXL9uu6zj5PEr2sger+aPm2IUH1HOKbbMRLVxjemntxab\nQubvyXGJqGOV53ZYu43nTCM1GJf2m6DQX8uo+tJcS3kRR42QYnco5r/uzpGl\ndVmRB3ANsOSpvdYxrc9rMTZ7mJk76Gm4wCW5Dcr5pqHgxI3kByJZPewDmITZ\n7Rq8A8T/Q2m7rk/My2BxFEULFir9a7Soo4x7tBad/k5e+0IxYELI/uBBQusk\nmbcoM52rqem4vHVtGxISYTkziLVSfyD8g3+AHuVnVdXGCPjWOgJc7DKlZFYb\nbpn+zy/puRQHj1N2HhxIGhdUj+iS7hw14As96xlHyQ==\n",
    #             "sign":"go2WCLlUgI2qQvs6T5mN2/XbF/VOeUNSu0IDsq1RlvMMDo3SFFGn64RqPEOF\nPEPLKqXk54Bg5qfXRtzF78ha4OvSagfNABpdcHa6HTbnZzq+OCoJl/PqfJb9\nrRuXfjQjLsgBv89KWgYkOs27wJ6n6hsDTtlIGzsrXVm4Wpx/Jt52umwXIaEi\ncVVULKZIfsN6KsVdvcm3f9wxEj3ZAjNDrax6UiC3pWFSiEUfAbG2Qvd9JT5G\nPlBwXN0dmxgeG4vG5v4rL91r9QfOTqtX/weten+ZCp1TVgcETbEKi/vWOuSR\nGv2XXDsAHsspLha1VnFG+F9MXtPXpDNpXbJP1jOWwA==\n",
    #             "pubkey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApja+JB+2SKRyGvRszoTM\ndjiKVgMfSZL7drHFJQ+CoD0wzthEPawWRWHEhdkGzZWGyXGX07X5g9dKBRFWCqVA\nqXxH6T940hE6A+0baXAltJLsAkno70gCj6tAfWneEKmwhN6/lAthn3dyucH3EXTY\no12uCw9k6r3LHnVQI/7QnakjI9sDQPXTjVSDk+ILUcBG3Numy1o4o8onJ0LsqvGC\nEkPi/xr0lRwSr/UX/D7pcW8UxGl63rcvje/cEvE/06gMvFKKP29/nFXXmDm6u3Vc\nnmHwUccjTthQiGVBHELKbPl7OPZM02jBMF1Aria4mNRktJMLRiCawM5FDeSw/fqo\nxwIDAQAB\n-----END PUBLIC KEY-----\n"
    #         }'

    #     post '/miner/pool/submit', json_payload, {format: 'json'}

    #     puts last_response.body
    # end

    # get /miner/mine/create_merkle
    it "should create merkle tree" do
        # sebelum testing, harus dibuat dulu banyak data dalam database
        MINE = 1

        get '/miner/mine'

        puts last_response.body
    end
end
