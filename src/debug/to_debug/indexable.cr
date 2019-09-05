module Indexable(T)
  def to_debug(io) : Nil
    super(io)
    io << " <size: #{size.colorize(:light_gray)}>".colorize(:dark_gray)
  end
end
