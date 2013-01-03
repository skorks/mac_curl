module MacCurl
  module Requests
    extend MacCurl::ApiSigning

    def api_signed_get_request_for(api_key, api_secret, path, connection, options = {})
      response = connection.get do |req|
        req.url path
        add_api_key_header(req, api_key, api_secret, path)
        add_http_headers(req, options[:headers] || {})
        log_request(req)
      end
      response
    end

    def api_signed_post_request_for(api_key, api_secret, path, connection, options = {})
      response = connection.post do |req|
        req.url path
        add_api_key_header(req, api_key, api_secret, path)
        add_http_headers(req, options[:headers] || {})
        log_request(req)
      end
      response
    end

    def api_signed_request_for(request_method, api_key, api_secret, path, connection, options = {})
      response = connection.send(request_method.downcase.to_sym) do |req|
        req.url path
        add_api_key_header(req, api_key, api_secret, path)
        add_http_headers(req, options[:headers] || {})
        log_request(req)
      end
      response
    end

    def request_for(request_method, path, connection, options = {})
      response = connection.send(request_method.downcase.to_sym) do |req|
        req.url path
        add_http_headers(req, options[:headers] || {})
        log_request(req)
      end
      response
    end

    private

    def add_api_key_header(req, api_key, api_secret, path)
      req.headers['X-PlayUp-Api-Key'] = api_key_header_value_for(api_key, api_secret, path)
    end

    def add_http_headers(req, headers)
      headers.each_pair do |header, value|
        req.headers[header] = value
      end
    end

    def log_request(req)
      MacCurl::Logging.logger.debug{ "Request parameters: #{req}" }
    end
  end
end
