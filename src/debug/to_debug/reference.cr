class Reference
  def to_debug(io) : Nil
    colors = Debug.settings.colors

    io << self
      .pretty_inspect(indent: 2)
      .colorize(colors[:value])
  end
end
