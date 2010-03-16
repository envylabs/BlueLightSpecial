require File.join(File.dirname(__FILE__), 'boot')
require 'digest/md5'

Rails::Initializer.run do |config|
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))
  config.action_controller.session = {
    :session_key => "_blue_light_special_session",
    :secret      => ['blue_light_special', 'random', 'words', 'here'].map {|k| Digest::MD5.hexdigest(k) }.join
  }

  config.gem "justinfrench-formtastic", 
    :lib     => 'formtastic', 
    :source  => 'http://gems.github.com'
  
  config.gem "mini_fb", 
    :version => '=0.2.2'
  
  config.gem "delayed_job", 
    :version => '=1.8.4'

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
end
