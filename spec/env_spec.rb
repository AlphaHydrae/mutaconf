require 'helper'

describe "Mutaconf.env" do

  it "should extract properties from environment variables" do
    ENV['FOO'] = 'bar'
    ENV['BAR'] = 'foo'
    ENV.delete 'NIL'
    Mutaconf.env(:foo, :bar, :nil).should == { foo: 'bar', bar: 'foo', nil: nil }
  end

  it "should not upcase keys if specified" do
    ENV['foo'] = 'bar'
    ENV['bar'] = 'foo'
    Mutaconf.env(:foo, :bar, upcase: false).should == { foo: 'bar', bar: 'foo' }
  end

  it "should use the given prefix" do
    ENV['MUTACONF_FOO'] = 'bar'
    ENV['MUTACONF_BAR'] = 'foo'
    Mutaconf.env(:foo, :bar, prefix: :mutaconf_).should == { foo: 'bar', bar: 'foo' }
  end
end
