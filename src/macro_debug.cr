module Debug
  # This constant contains the colors used when highlighting macro
  # debugging statements via `mdebug!`. For more information on these
  # codes, see this link:
  # [https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit)
  MDEBUG_COLORS = {
    :severity => "82",
    :separator => "230",
    :file => "8",
    :lineno => "8",
    :message => "15"
  }
end

# This is the main macro level debugging statement. It takes a message, and
# an optional severity level, and outputs, during macro evaluation, the
# debugging statement, highlighted according to the color codes in the
# `Debug::MDEBUG_COLORS` constant.
#
# If debugging is not active (either the `DEBUG` flag is not set, or the
# `DEBUG` environment variable is not set to a truthy value), this macro
# will do nothing.
macro macro_debug!(message,
                   severity = :debug,
                   file = __FILE__,
                   line = __LINE__)
  {% if ::Debug::ACTIVE %}
    \{%
      puts [
      "\e[38;5;{{ ::Debug::MDEBUG_COLORS[:severity].id }}m{{ severity.upcase.id }}\e[0m",
      "\e[38;5;{{ ::Debug::MDEBUG_COLORS[:separator].id }}m -- \e[0m",
      "\e[38;5;{{ ::Debug::MDEBUG_COLORS[:file].id }}m{{ file.id }}\e[0m",
      "\e[38;5;{{ ::Debug::MDEBUG_COLORS[:separator].id }}m:\e[0m",
      "\e[38;5;{{ ::Debug::MDEBUG_COLORS[:lineno].id }}m{{ line }}\e[0m",
      "\e[38;5;{{ ::Debug::MDEBUG_COLORS[:separator].id }}m -- \e[0m",
      "\e[38;5;{{ ::Debug::MDEBUG_COLORS[:message].id }}m{{ message.id }}\e[0m"].join("")
    %}
  {% end %}
end
