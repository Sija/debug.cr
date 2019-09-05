struct Pointer(T)
  def to_debug(io) : Nil
    colors = Debug.settings.colors

    io << "0x#{address.to_s(16)}"
      .colorize(colors[:value])

    unless null?
      io << " <value: "
        .colorize(colors[:decorator])
      io << value
        .colorize(colors[:meta])
      io << ">"
        .colorize(colors[:decorator])
    end
  end
end
