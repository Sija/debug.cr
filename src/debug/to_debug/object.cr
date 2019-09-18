class Object
  def to_debug(io) : Nil
    io << self
      .pretty_inspect(indent: 2)
      .colorize(Debug.settings.colors[:value])
  end

  def to_debug : String
    # https://github.com/crystal-lang/crystal/issues/8198
    String.build { |io| to_debug(io) }
  end
end
