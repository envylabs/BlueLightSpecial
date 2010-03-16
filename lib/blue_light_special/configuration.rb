module BlueLightSpecial
  class Configuration
    attr_accessor :mailer_sender
    attr_accessor :impersonation_hash
    attr_accessor :use_facebook_connect
    attr_accessor :facebook_api_key
    attr_accessor :facebook_secret_key

    def initialize
      @mailer_sender          = 'donotreply@example.com'
      @impersonation_hash     = 'e76e05e1ddf74560ffb64c02a1c1b26c'
      @user_facebook_connect  = false
    end
  end

  class << self
    attr_accessor :configuration
  end

  # Configure BlueLightSpecial someplace sensible,
  # like config/initializers/blue_light_special.rb
  #
  # @example
  #   BlueLightSpecial.configure do |config|
  #     config.mailer_sender = 'donotreply@example.com'
  #     config.impersonation_hash = 'abc123def456...'
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
