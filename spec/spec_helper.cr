require "spec"
require "log/spec"
require "../src/debug"

Debug.configure do |settings|
  settings.location_detection = :compile
  settings.max_path_length = nil
end

macro assert_debug(exp, *, file = __FILE__, line = __LINE__)
  %ret = nil

  ::Log.capture do |%logs|
    %ret, %value =
      debug!(__value__ = {{ exp }}),
      __value__

    case %value
    when Value     then %ret.should eq %value
    when Reference then %ret.should be %value
    end

    %ret.should be_a typeof(%value)

    if ::Debug::ACTIVE && ::Debug.enabled?
      %relative_path = Path[{{ file }}].relative_to(Dir.current).to_s

      %entry = %logs.check("whatever", &.nil?.!).entry?.should_not be_nil # here be dragons
      %entry.severity.should eq ::Log::Severity::Debug
      %entry.message.should contain "#{%relative_path}:{{ line }}"
      %entry.message.should contain {{ exp.stringify }}
    else
      %logs.empty
    end
  end

  %ret
end
