module MacCurl
  class Command
    class << self
      def for(config, global_options, command_options, arguments)
        @config = config
      end
    end

    attr_reader :url, :config

    def initialize(config, url, options = {})
      @config = config
      @url = url
    end

    def execute
      raise "Needs to be implemented by child class"
    end
  end
end
