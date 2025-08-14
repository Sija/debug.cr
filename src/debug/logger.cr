module Debug
  Log = ::Log.for("debug")

  private DEFAULT_FORMATTER = ::Log::Formatter.new do |entry, io|
    parts = [] of String

    Logger.settings.tap do |settings|
      if settings.show_severity? && (severity = entry.severity)
        parts << severity.label.to_s.rjust(6).colorize(settings.severity_colors[severity]).to_s
      end
      if settings.show_datetime? && (timestamp = entry.timestamp)
        parts << "[#{timestamp.to_s.colorize(settings.colors[:datetime])}]"
      end
      progname = entry.data[:progname]?.try(&.as_s?) || settings.progname
      if settings.show_progname? && progname.presence
        parts << "[#{progname.colorize(settings.colors[:progname])}]"
      end
      unless parts.empty?
        io.tap { parts.join(io, ' ') } << " -- "
      end
      io << entry.message
    end
  end

  ::Log.setup do |c|
    backend = ::Log::IOBackend.new(STDOUT, formatter: DEFAULT_FORMATTER)

    c.bind "debug.*", :trace, backend
  end
end

require "./logger/*"
