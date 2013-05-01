require 'helper'
require 'ostruct'

describe "Mutaconf.extract" do

  class Source
    attr_accessor :a, :c

    def initialize
      @a, @c = 'b', 'd'
    end
  end

  it "should extract properties from a hash" do
    s = { a: 'b', c: 'd' }
    expect(Mutaconf.extract(s, :a)).to eq('b')
    expect(Mutaconf.extract(s, :c)).to eq('d')
    expect(Mutaconf.extract(s, :e)).to be_nil
  end

  it "should extract properties from an open struct" do
    s = OpenStruct.new a: 'b', c: 'd'
    expect(Mutaconf.extract(s, :a)).to eq('b')
    expect(Mutaconf.extract(s, :c)).to eq('d')
    expect(Mutaconf.extract(s, :e)).to be_nil
  end

  it "should extract properties from an object" do
    s = Source.new
    expect(Mutaconf.extract(s, :a)).to eq('b')
    expect(Mutaconf.extract(s, :c)).to eq('d')
    expect{ Mutaconf.extract s, :e }.to raise_error(NoMethodError)
  end

  it "should return a string or symbol" do
    expect(Mutaconf.extract('string', :a)).to eq('string')
    expect(Mutaconf.extract(:symbol, :c)).to eq(:symbol)
  end

  it "should not symbolize the key if specified" do
    s = { 'a' => 'b', :c => 'd' }
    expect(Mutaconf.extract(s, 'a', symbolize: false)).to eq('b')
    expect(Mutaconf.extract(s, 'c', symbolize: false)).to be_nil
  end
end
