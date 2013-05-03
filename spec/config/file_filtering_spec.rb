require 'helper'
require 'yaml'

describe 'file filtering' do
  include FakeFS::SpecHelpers

  let :all_files do
    [
      '/cwd/.foo', '/cwd/.foorc', '/cwd/.foo.rc', '/cwd/.foo.conf', '/cwd/.foo.rb', # 0-4
      '~/.foo', '~/.foorc', '~/.foo.rc', '~/.foo.conf', '~/.foo.rb',                # 5-9
      '/etc/foo', '/etc/foorc', '/etc/foo.rc', '/etc/foo.conf', '/etc/foo.rb'       # 10-14
      # plain: 0, 5, 10; rc: 1, 6, 11; dotrc: 2, 7, 12; conf: 3, 8, 13; format: 4, 9, 14
    ].collect{ |f| File.expand_path f }
  end

  let(:find_args){ [ 'foo' ] }
  let(:find_options){ { all: true } }
  let(:subject_args){ find_args + (find_options.empty? ? [] : [ find_options ]) }
  subject{ Mutaconf::Config.find_file *subject_args }

  before :each do
    [ '/cwd', '/etc', '~' ].each{ |dir| FileUtils.mkdir_p File.expand_path(dir) }
    all_files.each{ |f| FileUtils.touch f }
    Dir.chdir '/cwd'
  end

  it{ should eq(all_files) }

  [
    { location: :cwd }, { locations: [ :cwd ] }, { locations: { only: :cwd } }, { locations: { only: [ :cwd ] } },
    { locations: { only: [ :cwd, :home ], except: :home } }
  ].each do |options|
    context "with options #{options}" do
      let(:find_options){ super().merge options }
      it{ should eq(all_files[0, 5]) }
    end
  end

  [ { locations: { except: :home } }, { locations: { except: [ :home ] } } ].each do |options|
    context "with options #{options}" do
      let(:find_options){ super().merge options }
      it{ should eq(all_files[0, 5] + all_files[10, 5]) }
    end
  end

  [ { locations: [ :home, :etc ] }, { locations: { only: [ :home, :etc ] } } ].each do |options|
    context "with options #{options}" do
      let(:find_options){ super().merge options }
      it{ should eq(all_files[5, 10]) }
    end
  end

  [ { locations: { except: [ :cwd, :home ] } } ].each do |options|
    context "with options #{options}" do
      let(:find_options){ super().merge options }
      it{ should eq(all_files[10, 5]) }
    end
  end

  [
    { type: :plain }, { types: [ :plain ] }, { types: { only: :plain } }, { types: { only: [ :plain ] } },
    { types: { only: [ :plain, :rc, :conf ], except: [ :rc, :conf ] } }
  ].each do |options|
    context "with options #{options}" do
      let(:find_options){ super().merge options }
      it{ should eq(all_files.select.with_index{ |f,i| i % 5 == 0 }) }
    end
  end

  [ { types: { except: :rc } }, { types: { except: [ :rc ] } } ].each do |options|
    context "with options #{options}" do
      let(:find_options){ super().merge options }
      it{ should eq(all_files.select.with_index{ |f,i| i % 5 != 1 }) }
    end
  end

  [ { types: [ :dotrc, :conf ] }, { types: { only: [ :dotrc, :conf ] } } ].each do |options|
    context "with options #{options}" do
      let(:find_options){ super().merge options }
      it{ should eq(all_files.select.with_index{ |f,i| [ 2, 3 ].include? i % 5 }) }
    end
  end

  [ { types: { except: [ :conf, :format ] } } ].each do |options|
    context "with options #{options}" do
      let(:find_options){ super().merge options }
      it{ should eq(all_files.select.with_index{ |f,i| i % 5 < 3 }) }
    end
  end
end
