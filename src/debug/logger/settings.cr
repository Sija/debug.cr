class Debug::Logger
  class Settings
    private module LoggerDelegators
      delegate :logger, :logger=, to: Debug
      delegate :level, to: :logger

      def level=(level : Log::Severity)
        logger.level = level
      end
    end

    extend LoggerDelegators

    class_property? show_severity = true
    class_property? show_datetime = false
    class_property? show_progname = true

    class_property progname : String?

    class_getter colors = {
      :datetime => :dark_gray,
      :progname => :cyan,
    } of Symbol => Colorize::Color

    class_getter severity_colors = {
      :trace  => :white,
      :debug  => :green,
      :info   => :blue,
      :notice => :dark_gray,
      :warn   => :light_red,
      :error  => :red,
      :fatal  => :magenta,
    } of Log::Severity => Colorize::Color
  end

  class_getter settings = Settings

  def self.configure : Nil
    yield settings
  end
end
