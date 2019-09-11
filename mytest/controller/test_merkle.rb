require 'openssl'
require "test/unit"

require_relative '../../controller/merkle'

class TestMerkle < Test::Unit::TestCase

    test "create merkleroot from one hash" do

        hash_arr = ["3063511669ee8273063dce105008d23780e6e9a84d94038353e6ab24b25b5fcf"]

        expect_merkleroot = "11de880a4d10f5b2aaa2d4e0280d1040b044d0b903d474e5de77d8d3d0bbbdba"

        assert(expect_merkleroot, Merkle.create(hash_arr))

    end

    test "create merkleroot from two hashes" do

        hash_arr = ["3063511669ee8273063dce105008d23780e6e9a84d94038353e6ab24b25b5fcf","000caf794e47a613d9000a4dce1b37ab4894502c9fc218fc49019ab112708601"]

        expect_merkleroot = "30457c3d6d82441e5b8aaa88b19ac1e811e8e8780405a3fe1d9528248863d8a9"

        assert(expect_merkleroot, Merkle.create(hash_arr))

    end

    test "create merkleroot from three hashes" do

        hash_arr = ["3063511669ee8273063dce105008d23780e6e9a84d94038353e6ab24b25b5fcf","000caf794e47a613d9000a4dce1b37ab4894502c9fc218fc49019ab112708601","000762b951668aed0c00ab95819457242654864beb09e14922d5d1d99d541043"]

        hash_one = "30457c3d6d82441e5b8aaa88b19ac1e811e8e8780405a3fe1d9528248863d8a9" # sha1 from 1 and 2
        hash_two = "ad46f67baf4c9defedfb018a422e1b93124ac0d908c7f6c2f574add978fc5ed8" # sha1 from 3 and 3

        expect_merkleroot = "6f5698cabaea0306440a619b374d96a49df78e2f5ada07b0a5f92beb3f728dde"

        assert(expect_merkleroot, Merkle.create(hash_arr))

    end

end
