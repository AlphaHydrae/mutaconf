require 'helper'

describe 'find one file' do
  include FakeFS::SpecHelpers

  let(:find_args){ [ 'foo' ] }
  let(:find_options){ {} }
  let(:subject_args){ find_args + (find_options.empty? ? [] : [ find_options ]) }
  subject{ Mutaconf::Config.find_file *subject_args }

  let(:expected){ [] }

  before :each do
    FileUtils.mkdir_p '/cwd'
    FileUtils.mkdir_p '/etc'
    FileUtils.mkdir_p File.expand_path('~')
  end

  shared_examples_for "find one file" do
    it{ expected.empty? ? should(be_nil) : should(eq(expected.first)) }

    context "with the all option" do
      let(:find_options){ super().merge all: true }
      it{ should eq(expected) }
    end
  end

  it_behaves_like "find one file"

  BASE = [ 'foo', 'foorc', 'foo.rc', 'foo.conf' ]
  FORMATS = { ruby: [ 'rb' ], yaml: [ 'yml', 'yaml' ], json: [ 'json' ] }
  LOCATIONS = [ '/etc', '~', nil ]

  shared_examples_for "find one existing file" do

    LOCATIONS.each do |location|
      location ||= '/cwd'

      context "in #{location}" do
        let(:dir){ location }

        FORMATS.each_pair do |format,exts|

          files = BASE.dup
          exts.each{ |ext| files << "foo.#{ext}" }

          files.each do |file|

            context "with one #{format} file #{file}" do
              let(:dot_part){ find_options[:dot] != false && dir != '/etc' ? '.' : nil }
              let(:path){ "#{dir}/#{dot_part}#{file}" }
              let(:find_options){ super().merge format: format }
              let(:expected){ [ File.expand_path(path) ] }

              before :each do
                File.dirname setup(path)
                Dir.chdir '/cwd'
              end

              it_behaves_like "find one file"
            end
          end
        end
      end
    end
  end

  it_behaves_like "find one existing file"

  context "with the dot option set to false" do
    let(:find_options){ super().merge dot: false }
    it_behaves_like "find one existing file"
  end

  context "in the /etc directory" do
    let(:file){ '/etc/foo.rc' }
    let(:expected){ [ File.expand_path(file) ] }
    before(:each){ Dir.chdir File.dirname(setup(file)) }
    it_behaves_like "find one file"
  end

  context "in the home directory" do
    let(:file){ '~/.foo.rc' }
    let(:expected){ [ File.expand_path(file) ] }
    before(:each){ Dir.chdir File.dirname(setup(file)) }
    it_behaves_like "find one file"
  end

  def setup file
    FileUtils.mkdir_p File.dirname(file)
    FileUtils.touch file
    file
  end
end
