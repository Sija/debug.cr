module Debug
  SEVERITY_COLORS = {
    Logger::Severity::UNKNOWN => :dark_gray,
    Logger::Severity::ERROR   => :red,
    Logger::Severity::WARN    => :light_red,
    Logger::Severity::INFO    => :blue,
    Logger::Severity::DEBUG   => :green,
    Logger::Severity::FATAL   => :magenta,
  }

  class_property logger : Logger do
    Logger.new(STDOUT).tap do |logger|
      logger.formatter = Logger::Formatter.new do |severity, _datetime, progname, message, io|
        io << severity.to_s.rjust(5).colorize(
          SEVERITY_COLORS[severity]? || SEVERITY_COLORS[Logger::Severity::UNKNOWN]
        )
        io << " [" << progname.colorize(:cyan) << ']' unless progname.empty?
        io << " -- " << message
      end
      logger.level = Logger::DEBUG
    end
  end
end
