require "log"
require "colorize"

module Debug
  {% begin %}
    ACTIVE = {{ env("DEBUG") == "1" }}
  {% end %}

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
            severity = :debug,
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

      {% if ::Debug::ACTIVE %}
        if ::Debug.enabled?
          %arg_expressions = {
            {% for arg in args %}
              {{ arg.stringify }},
            {% end %}
          }

          %settings = ::Debug.settings
          %colors = %settings.colors

          {% for arg, i in args %}
            ::Debug.logger.{{ severity.id }} do |%emitter|
              %exp, %val =
                %arg_expressions[{{ i }}], %arg_values[{{ i }}]

              %ret = String.build do |%str|
                case %settings.location_detection
                when .compile?
                  %relative_path = Path[{{ file }}].relative_to(Dir.current).to_s
                  if %relative_path
                    if %max_path_length = %settings.max_path_length
                      if %relative_path.size > %max_path_length
                        %relative_path = "…" + %relative_path[-%max_path_length..]
                      end
                    end
                    %str << "#{%relative_path}:{{ line }}"
                      .colorize(%colors[:path])
                  end

                  %def_name = {{ @def && @def.name.stringify }}
                  if %def_name
                    %str << " (#{%def_name})"
                      .colorize(%colors[:method])
                  end
                  %str << " -- "

                when .runtime?
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
                    %str << %caller
                      .colorize(%colors[:method])
                    %str << " -- "
                  end
                end

                %str << '\n' if %exp['\n']?
                %str << %exp
                  .colorize(%colors[:expression])

                %str << " = "
                  .colorize(%colors[:decorator])

                %val.to_debug.tap do |%pretty_val|
                  %str << '\n' if %pretty_val['\n']?
                  %str << %pretty_val
                end
                %str << " (" << typeof(%val).to_s.colorize(%colors[:type]) << ')'
              end

              %emitter.emit(%ret, progname: {{ progname }})
            end
          {% end %}
        end
      {% end %}

      {% if args.size == 1 %}
        %arg_values.first
      {% else %}
        %arg_values
      {% end %}
    {% end %}
  end
end

require "./debug/**"
