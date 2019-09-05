class Object
  def to_debug(io) : Nil
    io << self
      .pretty_inspect(indent: 2)
      .colorize(Debug.settings.colors[:value])
  end

  def to_debug : String
    String.build &->to_debug(IO)
  end
end
