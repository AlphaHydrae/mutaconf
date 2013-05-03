require 'helper'

describe 'find all files' do
  include FakeFS::SpecHelpers

  let(:foos){ [ '/cwd/.foo.conf', '~/.foo', '/etc/foo.rc' ] }
  let(:bars){ [ '/cwd/barrc', '~/bar.rb', '/etc/bar' ] }
  let(:files){ [ '/etc/fubar', '/etc/fuu.rc', '~/fooo', '/cwd/baarc' ] + foos + bars }

  before :each do
    FileUtils.mkdir_p '/cwd'
    FileUtils.mkdir_p '/etc'
    FileUtils.mkdir_p File.expand_path('~')
    Dir.chdir '/cwd'
    files.each{ |f| FileUtils.touch File.expand_path(f) }
  end

  let(:find_options){ { all: true } }
  subject{ Mutaconf::Config.find_file find_name, find_options }

  context "with dot files" do
    let(:find_name){ 'foo' }
    it{ should eq(foos.collect{ |f| File.expand_path f }) }
  end

  context "without dot files" do
    let(:find_name){ 'bar' }
    let(:find_options){ super().merge dot: false }
    it{ should eq(bars.collect{ |f| File.expand_path f }) }
  end
end
