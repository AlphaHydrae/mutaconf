# encoding: UTF-8

module Mutaconf
  VERSION = '0.1.1'

  def self.env *args
    options = args.last.kind_of?(Hash) ? args.pop : {}
    args.flatten.inject({}) do |memo,key|
      env_key = options[:upcase] == false ? key.to_s : key.to_s.upcase
      prefix = options[:prefix]
      prefix = prefix.upcase if prefix and options[:upcase] != false
      memo[key.to_sym] = ENV["#{prefix}#{env_key}"]
      memo
    end
  end

  def self.config *args, &block
    Config.find *args, &block
  end

  def self.config_file *args, &block
    Config.find_file *args, &block
  end

  def self.options *args

    source = args.shift
    options = args.last.kind_of?(Hash) ? args.pop : {}

    source = if source.kind_of? Hash
      source
    elsif source.kind_of? Array
      source.last.kind_of?(Hash) ? source.pop : {}
    else
      {}
    end

    args.inject({}) do |memo,k|

      if source.key? k
        memo[k] = source[k]
        source.delete k if options[:delete]
      end

      memo
    end
  end

  def self.extract source, key, options = {}
    key = key.to_sym if !options.key?(:symbolize) or options[:symbolize]
    if source.kind_of? Hash
      source[key]
    elsif source.kind_of?(String) or source.kind_of?(Symbol)
      source
    elsif source
      source.send key
    end
  end
end

Dir[File.join File.dirname(__FILE__), File.basename(__FILE__, '.*'), '*.rb'].each{ |lib| require lib }
