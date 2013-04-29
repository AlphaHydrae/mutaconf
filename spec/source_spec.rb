require 'helper'
require 'ostruct'

describe Mutaconf::DSL do

  let(:target){ {} }
  let(:dsl){ Mutaconf::DSL.new options }
  let(:options){ { attrs: { target => true } } }

  it "should configure properties from a hash source" do
    result = dsl.configure a: 'b', c: 'd'
    expected = { a: 'b', c: 'd' }
    result.should be(dsl)
    target.should == expected
  end

  it "should configure properties from a file with instance evaluation" do
    result = dsl.configure fixture(:eval)
    expected = { a: 'b', c: 'd', e: 'f', g: 'h' }
    result.should be(dsl)
    target.should == expected
  end

  context "with restricted keys" do

    let(:options){ { attrs: { target => [ :a ] } } }

    it "should raise a key error for an unknown key from a hash source" do
      lambda{ dsl.configure b: 'c' }.should raise_error(Mutaconf::KeyError, /'b'/)
    end

    it "should raise a key error for an unknown key from a file with instance evaluation" do
      lambda{ dsl.configure fixture(:eval) }.should raise_error(Mutaconf::KeyError, /'c'/)
    end
  end

  context "with restricted keys in lenient mode" do

    let(:options){ { attrs: { target => [ :a, :e ] }, lenient: true } }

    it "should configure restricted properties from a hash source" do
      result = dsl.configure a: 'b', c: 'd', e: 'f', g: 'h'
      expected = { a: 'b', e: 'f' }
      result.should be(dsl)
      target.should == expected
    end

    it "should configure restricted properties from an object" do
      result = dsl.configure OpenStruct.new(a: 'b', c: 'd', e: 'f', g: 'h')
      expected = { a: 'b', e: 'f' }
      result.should be(dsl)
      target.should == expected
    end

    it "should configure restricted properties from a file with instance evaluation" do
      result = dsl.configure fixture(:eval)
      expected = { a: 'b', e: 'f' }
      result.should be(dsl)
      target.should == expected
    end
  end

  def fixture name
    File.join File.dirname(__FILE__), 'fixtures', "#{name}.rb"
  end
end
