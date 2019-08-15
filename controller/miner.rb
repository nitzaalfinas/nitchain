class Miner 

    def self.save_pubkey
        
    end

    def self.pool_submit 

    end

    def self.create_merkle_tree
        # ambil semua data dari pool
        Mongo::Logger.logger.level = ::Logger::FATAL

        client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DATABASE_NAME)  
        # if client[:pools].insert_one(obj)
        #     client.close
        #     return true
        # else 
        #     return "ErrDB Pool"
        # end

        

    end
end