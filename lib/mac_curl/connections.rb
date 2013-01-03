require 'faraday'
require 'faraday_middleware'

module MacCurl
  module Connections
    def unauthenticated_http_connection(url, options = {})
      follow_redirect_limit = options[:follow_redirect_limit] || 3
      Faraday.new(:url => url) do |c|
        c.use FaradayMiddleware::FollowRedirects, limit: follow_redirect_limit
        c.adapter Faraday.default_adapter
      end
    end

    def authenticated_http_connection(url, mac_key, mac_secret, options = {})
      follow_redirect_limit = options[:follow_redirect_limit] || 3
      Faraday.new(:url => url) do |c|
        c.use FaradayMiddleware::FollowRedirects, limit: follow_redirect_limit
        c.request :hmac_authentication, mac_key, mac_secret
        c.adapter Faraday.default_adapter
      end
    end

    def secure_http_connection(url, options = {})
      Faraday.new(:url => url, :ssl => {:verify => false}) { |c| c.adapter Faraday.default_adapter }
    end
  end
end
