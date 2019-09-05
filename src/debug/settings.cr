module Debug
  class Settings
    class_property? show_backtrace : Bool = false
    class_property? show_path : Bool = true
    class_property max_path_length : Int32? = 30
  end

  class_getter settings = Settings

  def self.configure : Nil
    yield settings
  end
end
