module BlueLightSpecial
  class Configuration
    attr_accessor :mailer_sender

    def initialize
      @mailer_sender = 'donotreply@example.com'
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
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
