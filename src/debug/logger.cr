module Debug
  class Logger < ::Logger
    private DEFAULT_FORMATTER = Formatter.new do |severity, datetime, progname, message, io|
      parts = [] of String | Colorize::Object(String)

      Logger.settings.tap do |settings|
        if settings.show_severity?
          parts << severity.to_s.rjust(5).colorize(settings.severity_colors[severity])
        end
        if settings.show_datetime?
          parts << "[#{datetime.to_s.colorize(settings.colors[:datetime])}]"
        end
        if settings.show_progname? && !progname.empty?
          parts << "[#{progname.colorize(settings.colors[:progname])}]"
        end
        unless parts.empty?
          io.tap { parts.join(' ', io) } << " -- "
        end
        io << message
      end
    end

    def initialize(@io : IO?, @level = Severity::DEBUG, @formatter = DEFAULT_FORMATTER, @progname = "")
      super
    end
  end

  class_property logger : ::Logger { Logger.new(STDOUT) }
end

require "./logger/*"
