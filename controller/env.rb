if ENV == "test"
    KEYSTORE_PATH = "/Users/nitzaalfinas/DocB/app_group/blockchain/nitchain_user/data/TEST/keystore"
    MAIN_CONFIG_PATH = "/Users/nitzaalfinas/DocB/app_group/blockchain/nitchain_user/data/TEST/config"
    MAIN_POOL = 'http://localhost:4568'
    DATABASE_NAME = 'nitchain_test'
elsif ENV == "development"
    KEYSTORE_PATH = "/Users/nitzaalfinas/DocB/app_group/blockchain/nitchain_user/data/user/keystore"
    MAIN_CONFIG_PATH = "/Users/nitzaalfinas/DocB/app_group/blockchain/nitchain_user/data/config"
    MAIN_POOL = 'http://localhost:4568'
    DATABASE_NAME = 'nitchain_user'
end
