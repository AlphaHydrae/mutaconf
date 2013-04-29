require 'helper'

describe 'DSL proxies' do

  let(:target){ OpenStruct.new }
  let(:dsl){ Mutaconf::DSL.new options }
  let(:options){ { proxy: { target => true } } }
  let(:block){ lambda{} }

  it "should proxy method calls with instance evaluation" do
    target.should_receive(:a).with('b')
    target.should_receive(:c=).with('d')
    target.should_receive(:e).with('f', &block)
    result = dsl.configure do
      a 'b'
      self.c = 'd'
      e 'f', &block
    end
    result.should be(dsl)
  end

  it "should proxy method calls with a configuration object" do
    target.should_receive(:a=).with('b')
    target.should_receive(:c=).with('d')
    result = dsl.configure do |config|
      config.a = 'b'
      config.c = 'd'
    end
    result.should be(dsl)
  end

  context "with restricted keys" do

    let(:options){ { proxy: { target => [ :a ] } } }

    it "should raise a key error for a unknown key with instance evaluation" do
      lambda{ dsl.configure{ b 'c' } }.should raise_error(Mutaconf::KeyError, /'b'/)
    end

    it "should raise a key error for an unknown key with a configuration object" do
      lambda{ dsl.configure{ |config| config.b = 'c' } }.should raise_error(Mutaconf::KeyError, /'b'/)
    end
  end

  context "with restricted keys in lenient mode" do

    let(:options){ { proxy: { target => [ :a, :e ] }, lenient: true } }

    it "should configure restricted properties with instance evaluation" do
      target.should_receive(:a).with('b', &block)
      target.should_receive(:e).with('f')
      result = dsl.configure do
        a 'b', &block
        c 'd'
        e 'f'
        g 'h'
      end
      result.should be(dsl)
    end

    it "should configure restricted properties with a configuration object" do
      target.should_receive(:a=).with('b')
      target.should_receive(:e=).with('f')
      result = dsl.configure do |config|
        config.a = 'b'
        config.c = 'd'
        config.e = 'f'
        config.g = 'h'
      end
      result.should be(dsl)
    end
  end
end
