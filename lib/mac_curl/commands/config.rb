module MacCurl
  module Commands
    class Config < MacCurl::Command
      class << self
        def for(config, global_options, command_options, arguments)
          super if defined? super
          self.new(config, arguments.last, MacCurl::Hash.deep_merge(global_options, command_options)).execute
        end
      end

      attr_reader :read, :write, :config, :path

      def initialize(config, path, options = {})
        @config = config
        @path = path
        @read = options[:read]
        @write = options[:write]
      end

      def execute
        if write?
          full_path = path ? File.join(File.expand_path(path), MacCurl::Config.file_name) : nil
          MacCurl::Config.write(full_path)
        else
          STDOUT.puts "Currently active config file: #{config.file_path}"
          STDOUT.puts JSON.pretty_generate(config.config_hash)
        end
      end

      def write?
        @write
      end
    end
  end
end
