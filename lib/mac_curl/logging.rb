require 'logger'

module MacCurl
  class Logging
    class << self
      def log_file(path = nil)
        @log_file = path || STDOUT #||= File.open(AppConfig::Logging::LOG_FILE, "a+")
        @log_file.sync = true
        @log_file
      end

      def logger
        return @logger if @logger
        @logger ||= Logger.new(log_file)
        @logger.formatter = proc do |severity, datetime, progname, msg|
          "#{severity} [#{datetime.strftime("%d/%b/%Y %H:%M:%S")}] \"#{msg}\"\n"
        end
        @logger
      end
    end
  end
end
