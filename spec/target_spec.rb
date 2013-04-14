require 'helper'

describe Mutaconf::Target do

  subject{ Mutaconf::Target.new target }

  context "with a hash" do

    let(:target){ { a: 'z' } }

    it "should set values" do
      subject.set :a, 'b'
      subject.set :c, 'd'
      target.should == { a: 'b', c: 'd' }
    end

    it "should get values" do
      subject.get(:a).should == 'z'
    end

    it "should have all values" do
      ('a'..'z').each{ |key| subject.has?(key).should be_true }
    end
  end

  context "with an open struct" do

    let(:target){ OpenStruct.new a: 'z' }

    it "should set values" do
      subject.set :a, 'b'
      subject.set :c, 'd'
      target.a.should == 'b'
      target.c.should == 'd'
    end

    it "should get values" do
      subject.get(:a).should == 'z'
    end

    it "should have all values" do
      ('a'..'z').each{ |key| subject.has?(key).should be_true }
    end
  end

  context "with an object" do

    let(:target) do
      Class.new do
        attr_accessor :a, :c

        def initialize
          @a = 'z'
        end
      end.new
    end

    it "should set values" do
      subject.set :a, 'b'
      subject.set :c, 'd'
    end

    it "should get values" do
      subject.get(:a).should == 'z'
    end

    it "should have values corresponding to its setters" do
      subject.has?(:a).should be_true
      subject.has?(:b).should be_false
      subject.has?(:c).should be_true
      ('d'..'z').each{ |key| subject.has?(key).should be_false }
    end
  end
end
