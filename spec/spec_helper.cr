require "spec"
require "../src/debug"

Debug.configure do |settings|
  settings.location_detection = :compile
  settings.max_path_length = nil
end

macro assert_debug(exp, *, file = __FILE__, line = __LINE__)
  %ret = nil

  %previous_logger = Debug.logger
  begin
    IO::Memory.new.tap do |io|
      Debug.logger = Debug::Logger.new(io)
      Debug.logger.tap do |logger|
        %ret = debug!(value = {{ exp }})

        case value
        when Value     then %ret.should eq(value)
        when Reference then %ret.should be(value)
        end
        %ret.should be_a(typeof(value))

        if Debug::ACTIVE && Debug.enabled?
          relative_filename = {{ file }}.lchop(Dir.current + "/")

          io.to_s.should contain "#{relative_filename}:{{ line }}"
          io.to_s.should contain {{ exp.stringify }}
        else
          io.to_s.should be_empty
        end
      end
    end
  ensure
    Debug.logger = %previous_logger
  end

  %ret
end
