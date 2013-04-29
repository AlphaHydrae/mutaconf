require 'helper'

describe Mutaconf::DSL do

  class CustomDSL < Mutaconf::DSL
    attr_reader :value

    def initialize options = {}
      super options
      @value = 0
    end

    def increase by
      @value += by
    end
  end

  let(:target){ {} }
  let(:dsl){ CustomDSL.new attrs: { target => true } }

  it "should work when subclassed" do
    result = dsl.configure do
      a 'b'
      c 'd'
      increase 5
    end
    expected = { a: 'b', c: 'd' }
    result.should be(dsl)
    target.should == expected
    dsl.value.should == 5
  end
end
