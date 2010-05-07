require 'blue_light_special/extensions/errors'
require 'blue_light_special/extensions/rescue'

require 'blue_light_special/configuration'
require 'blue_light_special/routes'
require 'blue_light_special/authentication'
require 'blue_light_special/user'

require 'blue_light_special/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
