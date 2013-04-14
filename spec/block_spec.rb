require 'helper'

describe Mutaconf::DSL do

  let(:target){ {} }
  let(:dsl){ Mutaconf::DSL.new options }
  let(:options){ { target: target } }

  it "should configure properties with instance evaluation" do
    result = dsl.configure do
      a 'b'
      c 'd'
    end
    expected = { a: 'b', c: 'd' }
    result.should be(target)
    target.should == expected
  end

  it "should configure properties with a configuration object" do
    result = dsl.configure do |config|
      config.e = 'f'
      config.g = 'h'
      config.i = 'j'
    end
    expected = { e: 'f', g: 'h', i: 'j' }
    result.should be(target)
    target.should == expected
  end

  context "with restricted keys" do

    let(:options){ { target: target, keys: [ :a ] } }

    it "should raise a key error for a unknown key with instance evaluation" do
      lambda{ dsl.configure{ b 'c' } }.should raise_error(Mutaconf::KeyError, /'b'/)
    end

    it "should raise a key error for an unknown key with a configuration object" do
      lambda{ dsl.configure{ |config| config.b = 'c' } }.should raise_error(Mutaconf::KeyError, /'b'/)
    end
  end

  context "with restricted keys in lenient mode" do

    let(:options){ { target: target, keys: [ :a, :e ], lenient: true } }

    it "should configure restricted properties with instance evaluation" do
      result = dsl.configure do
        a 'b'
        c 'd'
        e 'f'
        g 'h'
      end
      expected = { a: 'b', e: 'f' }
      result.should be(target)
      target.should == expected
    end

    it "should configure restricted properties with a configuration object" do
      result = dsl.configure do |config|
        config.a = 'b'
        config.c = 'd'
        config.e = 'f'
        config.g = 'h'
      end
      expected = { a: 'b', e: 'f' }
      result.should be(target)
      target.should == expected
    end
  end
end
