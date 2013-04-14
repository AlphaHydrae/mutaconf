require 'ostruct'

module Mutaconf

  class Target
    attr_reader :object

    def initialize object
      @object = object
    end

    def set key, value
      if @object.kind_of? Hash
        @object[key.to_sym] = value
      else
        @object.send "#{key}=", value
      end
    end

    def get key
      if @object.kind_of? Hash
        @object[key.to_sym]
      else
        @object.send key.to_sym
      end
    end

    def has? key
      @object.kind_of?(Hash) or @object.kind_of?(OpenStruct) or @object.respond_to?("#{key}=")
    end
  end
end
