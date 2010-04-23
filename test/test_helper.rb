ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) +
                         "/rails_root/config/environment")
require 'rails/test_help'
require 'shoulda'

$: << File.expand_path(File.dirname(__FILE__) + '/..')
require 'blue_light_special'

begin
  require 'redgreen'
rescue LoadError
end

require File.join(File.dirname(__FILE__), '..', 'shoulda_macros', 'blue_light_special')

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

FakeWeb.allow_net_connect = false

require 'test/rails_root/test/factories/user.rb'
