require 'yaml'
require 'multi_json'

module Mutaconf

  class Config
    attr_reader :file, :parser
    DEFAULT_FORMAT = :ruby

    class Error < StandardError; end

    def initialize file, options = {}
      @file = file
      @parser = options[:parser]
    end

    def raw
      @raw ||= File.read @file
    end

    def contents
      @contents ||= @parser ? @parser.parse(raw) : raw
    end

    def self.find *args

      file_options = args.last.kind_of?(Hash) ? args.pop : {}
      options = [ :read, :load, :parser ].inject({}){ |memo,o| memo[o] = file_options.delete o; memo }
      file_options.delete :all

      parser = if options[:parser]
        options[:parser]
      elsif file_options[:format] == :yaml
        YamlParser.new
      elsif file_options[:format] == :json
        JsonParser.new
      end

      file = find_file *(args.push file_options)
      return nil unless file

      raise Error, "Parser must respond to :parse" if parser and !parser.respond_to?(:parse)
      config = Config.new file, parser: parser
      config.raw if options[:read]
      config.load if options[:load]

      yield config if block_given?
      config
    end

    def self.find_file *args

      options = args.last.kind_of?(Hash) ? args.pop : {}

      # TODO: support no format
      format = selected_format options
      all = options[:all]

      found = []

      args.each do |name|

        # TODO: check user-supplied locations for duplicates
        selected_locations(options).each do |location|

          prefix = dot?(location, options) ? '.' : nil
          path = location[:path] || File.expand_path(Dir.pwd)

          selected_types(options).each do |type|

            build_suffixes(format, type, options).each do |suffix|

              file = File.expand_path(File.join(path, "#{prefix}#{name}#{suffix}"))
              if File.file? file
                return file unless all
                found << file
              end
            end
          end
        end
      end

      all ? found : nil
    end

    class YamlParser

      def parse raw, options = {}
        YAML.load raw
      end
    end

    class JsonParser

      def parse raw, options = {}
        MultiJson.load raw, options
      end
    end

    private

    def self.dot? location, options = {}
      (options.key?(:dot) ? options[:dot] : true) and (location.key?(:dot) ? location[:dot] : true)
    end

    def self.selected_format options = {}
      options[:format] || DEFAULT_FORMAT
    end

    def self.build_suffixes format, type, options = {}

      suffixes = type[:suffix]
      if suffixes == :format
        exts = FORMATS[format][:extension]
        exts = [ exts ] unless exts.kind_of? Array
        suffixes = exts.collect{ |ext| ".#{ext}" }
      end

      suffixes = [ suffixes ] unless suffixes.kind_of? Array
      suffixes
    end

    def self.selected_types options = {}
      filter TYPES, options[:types] || options[:type], TYPES.collect{ |t| t[:name] }
    end

    def self.selected_locations options = {}
      locations = filter LOCATIONS, options[:locations] || options[:location], LOCATIONS.collect{ |l| l[:name] }
      locations.delete_if{ |l| l[:name] == :cwd } if locations.any?{ |l| l[:name] != :cwd && File.expand_path(Dir.pwd) == File.expand_path(l[:path]) }
      locations
    end

    def self.filter a, criteria, defaults
      filters = build_filters criteria, defaults
      a.select{ |o| filters[:only].include? o[:name] }.reject{ |o| filters[:except].include? o[:name] }
    end

    def self.build_filters criteria, defaults
      h = criteria.kind_of?(Hash) ? criteria : { only: criteria.kind_of?(Array) ? criteria : [ criteria ].compact }
      h[:only] = defaults if h[:only].nil? or h[:only].empty?
      h[:only] = [ h[:only] ].compact unless h[:only].kind_of?(Array)
      h[:except] = [ h[:except] ].compact unless h[:except].kind_of?(Array)
      h
    end

    FORMATS = {
      ruby: {
        extension: 'rb'
      },
      yaml: {
        extension: [ 'yml', 'yaml' ],
        parser: YamlParser
      },
      json: {
        extension: 'json',
        parser: JsonParser
      }
    }

    LOCATIONS = [
      { name: :cwd },
      { name: :home, path: '~' },
      { name: :etc, path: '/etc', dot: false }
    ]

    TYPES = [
      { name: :plain },
      { name: :rc, suffix: 'rc' },
      { name: :dotrc, suffix: '.rc'},
      { name: :conf, suffix: '.conf'},
      { name: :format, suffix: :format }
    ]
  end
end
