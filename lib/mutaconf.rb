# encoding: UTF-8

module Mutaconf
  VERSION = '0.2.0'

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
end

Dir[File.join File.dirname(__FILE__), File.basename(__FILE__, '.*'), '*.rb'].each{ |lib| require lib }
