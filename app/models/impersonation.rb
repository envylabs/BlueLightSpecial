module Impersonation
  
  ##
  # Returns a hash based on the given id.
  # 
  def self.hash_for(id)
    raise(ArgumentError, "Must provide an id") unless id
    generate_hash(id)
  end
  
  ##
  # Returns +true+ if the given hash is valid for the given id.
  # 
  def self.valid_hash?(id, hash)
    hash == generate_hash(id)
  end
  
  
  private
  
  
  def self.generate_hash(id)
    Digest::MD5.hexdigest("----#{id}-----#{BlueLightSpecial.configuration.impersonation_hash}-----")
  end
  
end
