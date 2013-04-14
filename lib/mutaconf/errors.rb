
module Mutaconf

  class Error < StandardError; end

  class KeyError < Error
    attr_reader :key
  
    def initialize key
      super "No such property '#{key}'"
      @key = key
    end
  end
end
