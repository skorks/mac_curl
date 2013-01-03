require 'fileutils'
require 'pathname'
require 'json'

module MacCurl
  class Config
    class << self
      def find
        configs = []
        Pathname.new(Dir.pwd).descend do |path|
          file_path = File.join(path, file_name)
          if File.exists?(file_path)
            configs << file_path
          end
        end
        configs.empty? ? nil : configs.last
      end

      def write(path = nil, hash = nil)
        path ||= default_path
        path = File.expand_path(path)
        hash ||= default_config
        File.open(path,"w") do |f|
          f.puts JSON.pretty_generate(hash)
        end
        path
      end

      def write_default
        write(default_path, default_config)
      end

      def default_path
        file_path = File.join(File.expand_path(ENV["HOME"]), file_name)
      end

      def file_name
        ".mac_curl.conf"
      end

      def default_config
        {
          "log_level" => "ERROR",
          "request_method" => "GET",
          "headers" => {
            "Content-Type" => "application/json",
            "Accept" => "application/json, application/vnd.playup.*, */*"
          },
          "api_key" => "com.playup.ios.live",
          "api_secret" => "QwFHK6n3WAqhDPiz"
          #"mac_credentials" => {
            #"http://blah.com/yadda" => {
              #"id" => "Pz9EogPecWPPWa3AVzximdvtVPuxxNex",
              #"secret" => "@pQ4qv+peV44K;la<gN+Ruo-:NCY>2nEDG:aD6DMo+v2jHkZtAn<ff1hYfejC:Ibe"
            #}
          #},
          #"request_body" => {
            #":type" => "application/vnd.playup.application.invitation.request+json",
            #"app_identifier" => "live"
          #}
        }
      end

      def load(file_path = nil)
        config_path = file_path || find
        json = File.read(config_path)
        config_hash = JSON.parse(json)
        self.new(config_hash, file_path)
      end
    end

    attr_reader :file_path, :config_hash

    def initialize(config_hash, file_path)
      @config_hash = config_hash
      @file_path = file_path
    end

    def [](key)
      @config_hash[key]
    end

    def write
      MacCurl::Config.write(file_path, config_hash)
    end

    def add_mac_credentials(url, credentials)
      @config_hash["mac_credentials"] ||= {}
      @config_hash["mac_credentials"][url] = credentials
      @config_hash["current_mac_key"] = mac_key_for(url)
      @config_hash["current_mac_secret"] = mac_secret_for(url)
    end

    def api_key
      @config_hash["api_key"]
    end

    def api_secret
      @config_hash["api_secret"]
    end

    def mac_key_for(url)
      @config_hash["mac_credentials"][url] ||= {}
      @config_hash["mac_credentials"][url]["id"]
    end

    def mac_secret_for(url)
      @config_hash["mac_credentials"][url] ||= {}
      @config_hash["mac_credentials"][url]["secret"]
    end

    def current_mac_key
      @config_hash["current_mac_key"]
    end

    def current_mac_secret
      @config_hash["current_mac_secret"]
    end

    def request_method
      @config_hash["request_method"] || "GET"
    end

    def headers
      @config_hash["headers"] || {}
    end
  end
end


