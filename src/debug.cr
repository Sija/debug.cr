require "logger"
require "colorize"

module Debug
  class_property? enabled : Bool?

  def self.enabled? : Bool
    case enabled = @@enabled
    when Nil
      ENV["DEBUG"]? == "1"
    else
      enabled
    end
  end

  macro log(*args,
            severity = Logger::Severity::DEBUG,
            progname = nil,
            backtrace_offset = 0,
            file = __FILE__,
            line = __LINE__)

    {% unless args.empty? %}
      %arg_values = {
        {% for arg in args %}
          {{ arg }},
        {% end %}
      }

      if ::Debug.enabled?
        %arg_expressions = {
          {% for arg in args %}
            {{ arg.stringify }},
          {% end %}
        }

        %str = String.build do |%str|
          if ::Debug.settings.show_path?
            %relative_filepath = {{ file }}.lchop(Dir.current + "/")
            if %relative_filepath
              if %max_path_length = ::Debug.settings.max_path_length
                if %relative_filepath.size > %max_path_length
                  %relative_filepath = "…" + %relative_filepath[-%max_path_length..]
                end
              end
              %str << "#{%relative_filepath}:{{ line }}".colorize(:dark_gray)
            end

            %def_name = {{ @def && @def.name.stringify }}
            if %def_name
              %str << " (#{%def_name})".colorize(:dark_gray)
            end
            %str << " -- "
          end

          if ::Debug.settings.show_backtrace?
            %DEBUG_CALLER_PATTERN = /caller:Array\(String\)/i
            %caller_list = caller

            if %caller_list.any?(&.match(%DEBUG_CALLER_PATTERN))
              while !%caller_list.empty? && %caller_list.first? !~ %DEBUG_CALLER_PATTERN
                %caller_list.shift?
              end
              %caller_list.shift?
            end

            {% if backtrace_offset > 0 %}
              %caller_list.shift({{ backtrace_offset }})
            {% end %}

            if %caller = %caller_list.first?
              %str << %caller.colorize(:dark_gray)
              %str << " -- "
            end
          end

          {% for arg, i in args %}
            %exp, %val =
              %arg_expressions[{{ i }}], %arg_values[{{ i }}]

            %str << %exp.colorize(:light_blue)
            %str << " = ".colorize(:light_gray)
            %val.to_debug(%str)
            %str << " (" << typeof(%val).to_s.colorize(:green) << ") "
          {% end %}
        end

        ::Debug.logger.log({{ severity }}, %str, {{ progname }})
      end

      {% if args.size == 1 %}
        %arg_values.first
      {% else %}
        %arg_values
      {% end %}
    {% end %}
  end
end

require "./debug/**"
