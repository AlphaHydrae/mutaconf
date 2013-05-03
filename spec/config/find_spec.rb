require 'helper'

describe 'find' do
  include FakeFS::SpecHelpers

  let(:file_found){ nil }
  let(:find_args){ [ 'foo' ] }
  let(:find_options){ {} }
  let(:subject_args){ find_args + (find_options.empty? ? [] : [ find_options ]) }
  subject{ Mutaconf::Config.find *subject_args }

  before :each do
    Mutaconf::Config.stub find_file: file_found
    Mutaconf::Config.any_instance.stub :raw
    Mutaconf::Config.any_instance.stub :load
  end

  it{ should be_nil }

  context "with a file" do
    let(:file_found){ '/foo' }
    before(:each){ FileUtils.touch file_found }

    it{ should be_a_kind_of(Mutaconf::Config) }
    its(:file){ should eq('/foo') }
    its(:parser){ should be_nil }

    it "should yield the configuration" do
      Mutaconf::Config.find(*subject_args) do |config|
        expect(config).to be_a_kind_of(Mutaconf::Config)
        expect(config.file).to eq('/foo')
      end
    end

    it "should raise an error if the given parser doesn't respond to :parse" do
      expect{ Mutaconf::Config.find('foo', parser: Object.new) }.to raise_error(Mutaconf::Config::Error)
    end

    context "for yaml files" do
      let(:find_options){ super().merge format: :yaml }
      it{ should be_a_kind_of(Mutaconf::Config) }
      its(:file){ should eq('/foo') }
      its(:parser){ should be_an_instance_of(Mutaconf::Config::YamlParser) }
    end

    context "for json files" do
      let(:find_options){ super().merge format: :json }
      it{ should be_a_kind_of(Mutaconf::Config) }
      its(:file){ should eq('/foo') }
      its(:parser){ should be_an_instance_of(Mutaconf::Config::JsonParser) }
    end

    context "and the parser option" do
      let(:parser){ double parse: nil }
      let(:find_options){ super().merge parser: parser }
      it{ should be_a_kind_of(Mutaconf::Config) }
      its(:file){ should eq('/foo') }
      its(:parser){ should be(parser) }
    end

    context "and the read option" do
      let(:find_options){ super().merge read: true }

      before :each do
        Mutaconf::Config.any_instance.should_receive(:raw)
        Mutaconf::Config.any_instance.should_not_receive(:load)
      end

      it{ should be_a_kind_of(Mutaconf::Config) }
      its(:file){ should eq('/foo') }
    end

    context "and the load option" do
      let(:find_options){ super().merge load: true }

      before :each do
        Mutaconf::Config.any_instance.should_receive(:load)
      end

      it{ should be_a_kind_of(Mutaconf::Config) }
      its(:file){ should eq('/foo') }
    end
  end
end
