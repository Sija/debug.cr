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
 * Can be used inside expressions

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     debug:
       github: Sija/debug.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "debug"
```

TODO: Write usage instructions here

## Configuration

You can change the global defaults by calling `Debug.configure` with a block:

```crystal
Debug.configure do |settings|
  settings.show_backtrace = true
  settings.show_path = true
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
