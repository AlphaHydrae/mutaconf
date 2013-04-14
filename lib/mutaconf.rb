# encoding: UTF-8

module Mutaconf
  VERSION = '0.0.4'

  def self.dsl *args
    DSL.new *args
  end
end

Dir[File.join File.dirname(__FILE__), File.basename(__FILE__, '.*'), '*.rb'].each{ |lib| require lib }
