class Debug::Logger
  class Settings
    private module LoggerDelegators
      delegate :logger, :logger=, to: Debug
      delegate :level, :progname, :progname=, to: :logger

      def level=(level : ::Logger::Severity)
        logger.level = level
      end
    end

    extend LoggerDelegators

    class_property? show_severity : Bool = true
    class_property? show_datetime : Bool = false
    class_property? show_progname : Bool = true

    class_getter colors = {
      :datetime => :dark_gray,
      :progname => :cyan,
    } of Symbol => Colorize::Color

    class_getter severity_colors = {
      :unknown => :dark_gray,
      :error   => :red,
      :warn    => :light_red,
      :info    => :blue,
      :debug   => :green,
      :fatal   => :magenta,
    } of Logger::Severity => Colorize::Color
  end

  class_getter settings = Settings

  def self.configure : Nil
    yield settings
  end
end
