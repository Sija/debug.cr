module Indexable(T)
  def to_debug(io) : Nil
    super(io)

    colors = Debug.settings.colors

    io << " <size: "
      .colorize(colors[:decorator])
    io << size
      .colorize(colors[:meta])
    io << ">"
      .colorize(colors[:decorator])
  end
end
