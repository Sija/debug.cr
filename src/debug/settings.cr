module Debug
  class Settings
    enum LocationDetection
      None
      Compile
      Runtime
    end

    class_property location_detection : LocationDetection = :compile
    class_property max_path_length : Int32? = 30

    class_getter colors = {
      :path       => :dark_gray,
      :method     => :dark_gray,
      :expression => :light_blue,
      :value      => :white,
      :type       => :green,
      :meta       => :light_gray,
      :decorator  => :dark_gray,
    } of Symbol => Colorize::Color
  end

  class_getter settings = Settings

  def self.configure : Nil
    yield settings
  end
end
