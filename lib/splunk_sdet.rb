require "splunk_sdet/version"

module SplunkSdet
  RSpec.configure do |config|
    config.before(:all) do
      #if this environment variable is set use it to choose the remote control server, otherwise localhost
      (ENV['RC_HOST'] == nil) ? rc_host = 'localhost' : rc_host = ENV['RC_HOST']
      (ENV['RC_PORT'] == nil) ? rc_port = '4444' : rc_port = ENV['RC_PORT']

    end
    end

  def symbolize_keys(hash)
    out = {}
    if hash.class == Hash
      out = hash.inject({}) {|memo,(k,v)| memo[k.to_sym] = symbolize_keys(v);memo}
    else
      out = hash
    end

    out
  end

  def generate_curl_command(curl)
    output = ["curl "]
    curl.headers.each {|k,v| output <<  "-H  '#{k}: #{v}'"}
    output << curl.url
    output << "-d '#{curl.post_body}'" unless curl.post_body.nil?

    output.join (" ")
  end




end
