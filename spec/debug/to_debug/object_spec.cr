require "../../spec_helper"

class FooToDebug
  def initialize(@bar : String); end
end

describe Debug do
  context "Object#to_debug" do
    it "works for Value-s" do
      true.to_debug.should contain "true"
      :foo.to_debug.should contain ":foo"
      438006.to_debug.should contain "438006"
    end

    it "works for Reference-s" do
      # class name
      FooToDebug.new("baz").to_debug.should contain "Foo"
      # ivar name
      FooToDebug.new("baz").to_debug.should contain "bar"
      # ivar value
      FooToDebug.new("baz").to_debug.should contain "baz"
    end
  end

  context "Object#to_debug(IO)" do
    it "works for Value-s" do
      str = String.build do |io|
        :foo.to_debug(io).should be_nil
      end
      str.should contain ":foo"
    end

    it "works for Reference-s" do
      str = String.build do |io|
        FooToDebug.new("whatever").to_debug(io)
      end
      str.should contain "whatever"
    end
  end
end
