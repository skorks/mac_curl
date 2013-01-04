module MacCurl
  class Command
    class << self
      def for(global_options, command_options, arguments)
        config = MacCurl::Config.find_and_load
        self.new(config, arguments, MacCurl::Hash.deep_merge(global_options, command_options)).execute
      end
    end

    attr_reader :config

    def initialize(config, arguments, options = {})
      @config = config
      @arguments = arguments
    end

    def execute
      raise "Needs to be implemented by child class"
    end
  end
end
