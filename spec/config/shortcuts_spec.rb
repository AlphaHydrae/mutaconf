require 'helper'

describe Mutaconf do

  let(:config){ double }
  before(:each){ stub_const 'Mutaconf::Config', config }

  it "should forward .config to Config.find" do
    block = lambda{}
    config.should_receive(:find).with('foo', 'bar', a: 'b', c: 'd', &block)
    Mutaconf.config 'foo', 'bar', a: 'b', c: 'd', &block
  end

  it "should forward .config_file to Config.find_file" do
    config.should_receive(:find_file).with('foo', 'bar', a: 'b', c: 'd')
    Mutaconf.config_file 'foo', 'bar', a: 'b', c: 'd'
  end
end
