require 'helper'

describe Mutaconf::Config do
  include FakeFS::SpecHelpers

  let(:config_file){ '/foo' }
  let(:config_options){ {} }
  let(:config_contents){ nil }
  let(:subject_args){ [ config_file ] + (config_options.empty? ? [] : [ config_options ]) }
  subject{ Mutaconf::Config.new *subject_args }

  before :each do
    if config_contents
      File.open(config_file, 'w'){ |f| f.write config_contents }
    else
      FileUtils.touch config_file
    end
  end

  it "should lazily read its file and contents" do
    expect(subject.instance_variable_get('@raw')).to be_nil
    expect(subject.instance_variable_get('@contents')).to be_nil
  end

  its(:file){ should eq('/foo') }
  its(:raw){ should eq('') }
  its(:contents){ should eq('') }
  its(:parser){ should be_nil }

  context "with contents bar" do
    let(:config_contents){ 'bar' }
    its(:file){ should eq('/foo') }
    its(:raw){ should eq('bar') }
    its(:contents){ should eq('bar') }
    its(:parser){ should be_nil }

    it "should cache its contents" do
      expect(subject.raw).to eq('bar')
      expect(subject.contents).to eq('bar')
      File.open(config_file, 'w'){ |f| f.write 'foo' }
      expect(subject.raw).to eq('bar')
      expect(subject.contents).to eq('bar')
    end

    context "with a magic parser" do
      let(:parser){ double parse: 'magic' }
      let(:config_options){ super().merge parser: parser }
      its(:file){ should eq('/foo') }
      its(:raw){ should eq('bar') }
      its(:contents){ should eq('magic') }
      its(:parser){ should be(parser) }
    end
  end
end
