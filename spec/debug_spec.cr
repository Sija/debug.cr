require "./spec_helper"
require "./debug/**"

class Foo
end

module Bar
end

enum Baz
  One
  Two
  Three
end

ENV_DEBUG_KEY = "DEBUG"

describe Debug do
  describe ".enabled?" do
    it "should be true when ENV debug key is set to '1'" do
      previous_env = ENV[ENV_DEBUG_KEY]?
      begin
        ENV[ENV_DEBUG_KEY] = "1"
        Debug.enabled?.should be_true
      ensure
        ENV[ENV_DEBUG_KEY] = previous_env
      end
    end

    it "should be false when ENV debug key is set to value other than '1'" do
      previous_env = ENV[ENV_DEBUG_KEY]?
      begin
        ENV[ENV_DEBUG_KEY] = "10"
        Debug.enabled?.should be_false
      ensure
        ENV[ENV_DEBUG_KEY] = previous_env
      end
    end

    it "should be false when ENV debug key is unset" do
      previous_env = ENV.delete(ENV_DEBUG_KEY)
      begin
        Debug.enabled?.should be_false
      ensure
        ENV[ENV_DEBUG_KEY] = previous_env
      end
    end

    it "setting explicit (non-nil) value should have priority over ENV" do
      previous_env = ENV.delete(ENV_DEBUG_KEY)
      begin
        Debug.enabled = true
        Debug.enabled?.should be_true
      ensure
        ENV[ENV_DEBUG_KEY] = previous_env
        Debug.enabled = nil
      end
    end
  end

  it "passes :severity as Log::Entry#severity" do
    next unless Debug.enabled?

    ::Log.capture do |logs|
      debug!("foo")
      debug!("bar", severity: :trace)

      logs.check :debug, /foo/
      logs.next :trace, /bar/
    end
  end

  it "passes :progname into Log::Entry#data" do
    next unless Debug.enabled?

    progname = "bar.cr"

    ::Log.capture do |logs|
      debug!("foo", progname: progname)

      logs.check :debug, /foo/

      entry = logs.entry?.should_not be_nil
      entry.data[:progname]?.should eq(progname)
    end
  end

  context "with literals" do
    it "works with Nil" do
      assert_debug nil
    end

    it "works with Int" do
      assert_debug 1
      assert_debug 1_u64
    end

    it "works with Float" do
      assert_debug 1.23
    end

    it "works with Bool" do
      assert_debug true
      assert_debug false
    end

    it "works with Char" do
      assert_debug '.'
      assert_debug '…'
    end

    it "works with String" do
      assert_debug "foo"
    end
  end

  context "with containers" do
    it "works with Tuple" do
      assert_debug({1, 2, 3})
    end

    it "works with Array" do
      assert_debug [1, 2, 3]
    end
  end

  context "with expressions" do
    it do
      assert_debug(1 + 2).should eq(3)
      assert_debug("foo" + "bar").should eq("foobar")
    end
  end

  context "with side-effects" do
    it do
      i = 1
      assert_debug(i += 1)
      i.should eq(2)
    end

    it do
      arr = [:foo]
      assert_debug(arr << :bar)
      arr.should eq([:foo, :bar])
    end
  end

  context "with user defined classes" do
    it "works for classes" do
      assert_debug Foo
    end

    it "works for objects" do
      assert_debug Foo.new
    end

    it "works for modules" do
      assert_debug Bar
    end

    it "works for enums" do
      assert_debug Baz
      assert_debug Baz::One
    end
  end
end
