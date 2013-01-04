require 'faraday'
require 'faraday_middleware'
require 'playup_helpers'
require 'mach'

module MacCurl
  module Commands
    class Request < MacCurl::Command
      include MacCurl::ApiSigning
      include MacCurl::Connections
      include MacCurl::Requests

      attr_reader :url, :request_method, :headers, :parsed_url, :api_key, :api_secret, :mac_key, :mac_secret

      def initialize(config, arguments, options = {})
        super if defined? super

        if arguments.last.nil?
          raise "Need a URL to make a request to"
        end
        @url = arguments.last
        @parsed_url = URI(@url)
        @request_method = options[:request_method] || @config.request_method || "GET"
        @headers = options[:header].inject({}) do |accumulator, header_string|
          key, value = header_string.split(':')
          accumulator[key.strip] = value.strip
        end
        @headers = MacCurl::Hash.deep_merge(@config.headers, @headers)
        @api_signed = options[:'api-signature']
        @mac_signed = options[:'mac-signature']
        @api_key = options[:api_key] || @config.api_key
        @api_secret = options[:api_secret] || @config.api_secret
        @mac_key = options[:mac_key] || @config.current_mac_key
        @mac_secret = options[:mac_secret] || @config.current_mac_secret
      end

      def execute
        ensure_api_credentials if api_key_signed?
        ensure_mac_credentials if mac_signed?
        connection = mac_signed? ? authenticated_http_connection(url, mac_key, mac_secret) : unauthenticated_http_connection(url)

        MacCurl::Logging.logger.debug{ "Making request to: #{url}, api_key_signed: #{api_key_signed?}, mac_signed: #{mac_signed?}" }

        status, headers, body = fetch_response(connection)
        STDOUT.puts body
      end

      def fetch_response(connection)
        options = {:headers => headers}
        response = api_key_signed? ? api_signed_request_for(request_method, api_key, api_secret, parsed_url.path, connection, options) : request_for(request_method, parsed_url.path, connection, options)
        ensure_mac_credentials_valid(response)
        [response.status, response.headers, response.body]
      rescue => e
        MacCurl::Logging.logger.error{ "Error when fetching data from #{url}: #{e.message}" }
        raise e
      end

      def ensure_mac_credentials_valid(response)
        if response.status == 401
          document = JSON.parse(response.body)
          MacCurl::Logging.logger.debug{ "Response status is: 401, response body is: #{document}" }
          raise "Got a 401, perhaps you're MAC credentials are wrong/stale, use 'mac_curl credentials' to get some new ones"
        end
      end

      def mac_signed?
        @mac_signed
      end

      def api_key_signed?
        @api_signed
      end

      def ensure_api_credentials
        if !api_key || !api_secret
          raise "Unable to perform request without an API key and secret"
        end
      end

      def ensure_mac_credentials
        if !api_key || !api_secret
          raise "Unable to perform request without MAC credentials"
        end
      end
    end
  end
end
