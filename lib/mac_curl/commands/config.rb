module MacCurl
  module Commands
    class Config < MacCurl::Command
      attr_reader :path, :read, :write

      def initialize(config, arguments, options = {})
        super if defined? super
        @path = arguments.last
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
