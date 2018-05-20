$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'splunk_sdet'
RSpec.configure do |config|
  config.before(:all) do
    #if this environment variable is set use it to choose the remote control server, otherwise localhost
    (ENV['RC_HOST'] == nil) ? rc_host = 'localhost' : rc_host = ENV['RC_HOST']
    (ENV['RC_PORT'] == nil) ? rc_port = '4444' : rc_port = ENV['RC_PORT']
end
    end
