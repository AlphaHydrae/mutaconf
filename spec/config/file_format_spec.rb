require 'helper'

describe 'file format' do
  include FakeFS::SpecHelpers

  let(:all_files){ [ '/cwd/.foo.rb', '~/.foo.yml', '/etc/foo.json' ] }

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
      it{ should eq(File.expand_path('~/.foo.yml')) }
    end

    context "with format :json" do
      let(:find_options){ super().merge format: :json }
      it{ should eq('/etc/foo.json') }
    end
  end
end
