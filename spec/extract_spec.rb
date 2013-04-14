require 'helper'

describe "Mutaconf.extract" do

  class Source
    attr_accessor :a, :c

    def initialize
      @a, @c = 'b', 'd'
    end
  end

  it "should extract properties from a hash" do
    s = { a: 'b', c: 'd' }
    Mutaconf.extract(s, :a).should == 'b'
    Mutaconf.extract(s, :c).should == 'd'
    Mutaconf.extract(s, :e).should be_nil
  end

  it "should extract properties from an open struct" do
    s = OpenStruct.new a: 'b', c: 'd'
    Mutaconf.extract(s, :a).should == 'b'
    Mutaconf.extract(s, :c).should == 'd'
    Mutaconf.extract(s, :e).should be_nil
  end

  it "should extract properties from an object" do
    s = Source.new
    Mutaconf.extract(s, :a).should == 'b'
    Mutaconf.extract(s, :c).should == 'd'
    lambda{ Mutaconf.extract s, :e }.should raise_error(NoMethodError)
  end

  it "should return a string or symbol" do
    Mutaconf.extract('string', :a).should == 'string'
    Mutaconf.extract(:symbol, :c).should == :symbol
  end
end
