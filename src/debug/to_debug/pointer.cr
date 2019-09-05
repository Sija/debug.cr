struct Pointer(T)
  def to_debug(io) : Nil
    io << "0x#{address.to_s(16)}".colorize(:white)
    unless null?
      io << " <value: #{value.colorize(:light_gray)}>".colorize(:dark_gray)
    end
  end
end
