require 'openssl'
require "test/unit"

require_relative '../../controller/merkle'

class TestMerkle < Test::Unit::TestCase

    test "create merkleroot from one hash" do

        hash_arr = ["3063511669ee8273063dce105008d23780e6e9a84d94038353e6ab24b25b5fcf"]

        expect_merkleroot = "1980736804b9073cc7550b56a4dcdb4f3b26c102"

        assert(expect_merkleroot, Merkle.create(hash_arr))

    end

    test "create merkleroot from two hashes" do

        hash_arr = ["3063511669ee8273063dce105008d23780e6e9a84d94038353e6ab24b25b5fcf","000caf794e47a613d9000a4dce1b37ab4894502c9fc218fc49019ab112708601"]

        expect_merkleroot = "53089b65fdbd1400d2d855b8771006625b7ac6a7"

        assert(expect_merkleroot, Merkle.create(hash_arr))

    end

    test "create merkleroot from three hashes" do

        hash_arr = ["3063511669ee8273063dce105008d23780e6e9a84d94038353e6ab24b25b5fcf","000caf794e47a613d9000a4dce1b37ab4894502c9fc218fc49019ab112708601","000762b951668aed0c00ab95819457242654864beb09e14922d5d1d99d541043"]

        hash_one = "53089b65fdbd1400d2d855b8771006625b7ac6a7" # sha1 from 1 and 2
        hash_two = "c7fe577dfb84111d0724ebc784e9cb7bc52af52d" # sha1 from 3 and 3

        expect_merkleroot = "c7b34b3b6e3c080010858730fd879f62ea4e73ed"

        assert(expect_merkleroot, Merkle.create(hash_arr))

    end

end
