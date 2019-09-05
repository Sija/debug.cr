module Debug
  class Settings
    class_getter logger_severity_colors = {
      :unknown => :dark_gray,
      :error   => :red,
      :warn    => :light_red,
      :info    => :blue,
      :debug   => :green,
      :fatal   => :magenta,
    } of Logger::Severity => Colorize::Color
  end

  class_property logger : Logger do
    colors = settings.logger_severity_colors

    Logger.new(STDOUT).tap do |logger|
      logger.formatter = Logger::Formatter.new do |severity, _datetime, progname, message, io|
        io << severity.to_s.rjust(5).colorize(colors[severity]? || colors[Logger::Severity::UNKNOWN])
        io << " [" << progname.colorize(:cyan) << ']' unless progname.empty?
        io << " -- " << message
      end
      logger.level = :debug
    end
  end
end
