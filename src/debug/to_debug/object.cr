class Object
  def to_debug(io) : Nil
    io << pretty_inspect(indent: 2).colorize(:white)
  end

  def to_debug : String
    String.build &->to_debug(IO)
  end
end
