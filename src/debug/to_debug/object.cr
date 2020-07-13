class Object
  abstract def to_debug(io) : Nil

  def to_debug : String
    # https://github.com/crystal-lang/crystal/issues/8198
    String.build { |io| to_debug(io) }
  end
end
