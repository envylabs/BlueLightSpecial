require 'test_helper'

class ImpersonationTest < ActiveSupport::TestCase
  
  context 'An Impersonation' do
    
    should 'generate a hash based on the id' do
      hash1 = Impersonation.hash_for(1)
      hash2 = Impersonation.hash_for(2)
      assert_not_equal(hash1, hash2)
    end
    
    should 'not generate a nil hash' do
      assert_not_nil(Impersonation.hash_for(23))
    end
    
    should 'not raise an exception for nil' do
      assert_raise(ArgumentError) do
        Impersonation.hash_for(nil)
      end
    end
    
  end
  
end
