# `debug!(…)`

[![Build Status](https://travis-ci.com/Sija/debug.cr.svg?branch=master)](https://travis-ci.com/Sija/debug.cr) [![Releases](https://img.shields.io/github/release/Sija/debug.cr.svg)](https://github.com/Sija/debug.cr/releases) [![License](https://img.shields.io/github/license/Sija/debug.cr.svg)](https://github.com/Sija/debug.cr/blob/master/LICENSE)

*A macro for `puts`-style debugging fans.*

Debuggers are great. But sometimes you just don't have the time and nerve to set
up everything correctly and just want a quick way to inspect some values at runtime.

This projects provides `debug!(…)` macro that can be used in all circumstances
where you would typically write `puts …` or `pp …`, but with a few extras.

## Features

 * Easy to read, colorized output
 * Prints file name, line number, function name and the original expression
 * Adds type information for the printed-out value
 * Specialized pretty-printers for selected classes and modules (like `Indexable`)
 * Can be used inside expressions

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     debug:
       github: Sija/debug.cr
   ```

2. Run `shards install`

3. Make sure you compile your program with ENV variable `DEBUG` set to `1`
  (for instance `DEBUG=1 shards build`). Otherwise all `debug!(…)` calls
  will become a no-op.

4. Once your program is compiled, you need to pass `DEBUG=1` again on the
  program start, in order to activate `debug!(…)` logging. Alternatively,
  you can call `Debug.enabled = true` within your code to achieve the same
  behaviour.

## Usage

```crystal
require "debug"

# You can use `debug!(...)` in expressions:
def factorial(n : Int)
  return debug!(1) if debug!(n <= 1)
  debug!(n * factorial(n - 1))
end

message = "hello"
debug!(message)

a = 2
b = debug!(3 * a) + 1

numbers = {b, 13, 42}
debug!(numbers)

debug!("this line is executed")

factorial(4)
```

The code above produces this output:

![debug!(…) macro output](https://i.imgur.com/tn0WnEL.png)

## Configuration

You can change the global defaults by calling `Debug.configure` with a block:

```crystal
Debug.configure do |settings|
  settings.max_path_length = 100

  settings.colors[:expression] = :magenta
  settings.colors[:value] = :yellow
end
```

There's also `Debug::Logger.configure` method which allows you to change
global defaults related to the logging itself.

```crystal
Debug::Logger.configure do |settings|
  settings.progname = "foo.cr"

  settings.show_severity = false
  settings.show_datetime = true
  settings.show_progname = true

  settings.colors[:datetime] = :dark_gray
  settings.colors[:progname] = :light_blue

  settings.severity_colors[:debug] = :cyan
  settings.severity_colors[:info] = :white
end
```

## Customization

If you want `debug!(…)` to work for your custom class, you can simply overload
`#to_debug(io)` method within your class.

```crystal
class Foo
  def to_debug(io)
    io << "Foo(@bar = " << @bar.to_s.colorize(:green) << ")"
  end
end
```

## Development

Run specs with:

```
crystal spec
```

## Contributing

1. Fork it (<https://github.com/Sija/debug.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [@Sija](https://github.com/Sija) Sijawusz Pur Rahnama - creator, maintainer
