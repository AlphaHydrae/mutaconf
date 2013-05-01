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
