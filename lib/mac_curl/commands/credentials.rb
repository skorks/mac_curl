module MacCurl
  module Commands
    class Credentials < MacCurl::Command
      include MacCurl::ApiSigning
      include MacCurl::Connections
      include MacCurl::Requests

      class << self
        def for(config, global_options, command_options, arguments)
          super if defined? super
          if arguments.last.nil?
            raise "Need a URL to make a request to"
          end
          self.new(config, arguments.last, MacCurl::Hash.deep_merge(global_options, command_options)).execute
        end
      end

      attr_reader :parsed_url, :api_key, :api_secret, :add_to_config

      def initialize(config, url, options = {})
        super if defined? super
        @parsed_url = URI(@url)
        @api_key = options[:api_key] || @config.api_key
        @api_secret = options[:api_secret] || @config.api_secret
        @direct = options[:direct]
        @add_to_config = options[:add_to_config]
      end

      def execute
        ensure_api_credentials
        unless direct?
          MacCurl::Logging.logger.debug{ "Making API signed request to discover credentials server to: #{url}" }
          response = api_signed_get_request_for(api_key, api_secret, parsed_url.path, unauthenticated_http_connection(url))
          credentials_document = ensure_credentials_document(response)
          url_for_credentials_server = credentials_server_url(credentials_document)
        else
          MacCurl::Logging.logger.debug{ "Hitting credentials server directly at: #{url}" }
          url_for_credentials_server = url
        end
        mac_credentials = fetch_credentials(url_for_credentials_server)
        write_to_config(mac_credentials, url_for_credentials_server) if add_to_config
        STDOUT.puts mac_credentials
      end

      def write_to_config(mac_credentials, url_for_credentials_server)
        config.add_mac_credentials(url_for_credentials_server, mac_credentials)
        config.write
      end

      def direct?
        @direct
      end

      def ensure_api_credentials
        if !api_key || !api_secret
          raise "Unable to get credentials without an API key and secret"
        end
      end

      def ensure_credentials_document(response)
        if response.status == 401
          credentials_document = JSON.parse(response.body)
          MacCurl::Logging.logger.debug{ "Response status is: 401, response body is: #{credentials_document}" }
          credentials_document
        else
          raise "Were expecting 401 when trying to discover credentials server url, but didn't get it!"
        end
      end

      def credentials_server_url(credentials_document)
        (credentials_document[":href"] || credentials_document[":self"]).tap do |url|
          MacCurl::Logging.logger.debug{ "Credentials server url is #{url}" }
        end
      end

      def fetch_credentials(url)
        parsed_url = URI(url)
        MacCurl::Logging.logger.debug{ "Making API signed request to credentials server: #{url}" }
        response = api_signed_post_request_for(api_key, api_secret, parsed_url.path, secure_http_connection(url))
        mac_credentials = JSON.parse(response.body)
        mac_credentials
      rescue => e
        MacCurl::Logging.logger.error{ "Error when fetching credentials from #{url}: #{e.message}" }
        raise e
      end
    end
  end
end
