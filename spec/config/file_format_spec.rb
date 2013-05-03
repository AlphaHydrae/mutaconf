require 'helper'

describe 'file format' do
  include FakeFS::SpecHelpers

  let(:all_files){ [ '/cwd/.foo.rb', '/cwd/.foo.yml', '/cwd/.foo.json', '/etc/foo' ] }

  let(:find_args){ [ 'foo' ] }
  let(:find_options){ {} }
  let(:subject_args){ find_args + (find_options.empty? ? [] : [ find_options ]) }
  subject{ Mutaconf::Config.find_file *subject_args }

  before :each do
    [ '/cwd', '/etc', '~' ].each{ |dir| FileUtils.mkdir_p File.expand_path(dir) }
    all_files.each{ |f| FileUtils.touch f }
    Dir.chdir '/cwd'
  end

  context "file" do

    it{ should eq('/cwd/.foo.rb') }

    context "with format :ruby" do
      let(:find_options){ super().merge format: :ruby }
      it{ should eq('/cwd/.foo.rb') }
    end

    context "with format :yaml" do
      let(:find_options){ super().merge format: :yaml }
      it{ should eq(File.expand_path('/cwd/.foo.yml')) }
    end

    context "with format :json" do
      let(:find_options){ super().merge format: :json }
      it{ should eq('/cwd/.foo.json') }
    end

    context "with format false" do
      let(:find_options){ super().merge format: false }
      it{ should eq('/etc/foo') }
    end
  end
end
