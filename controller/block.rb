class Block
    attr_accessor :timestamp, :last_hash, :hash, :data

    def initialize(timestamp, last_hash, hash, data)
        @timestamp = timestamp
        @last_hash = last_hash
        @hash = hash
        @data = data
    end

    def genesis
    end
end
