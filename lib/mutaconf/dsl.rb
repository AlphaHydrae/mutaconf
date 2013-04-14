
module Mutaconf

  class DSL
    attr_accessor :keys, :target, :lenient

    def initialize options = {}
      @keys ||= options[:keys] || [] # TODO: spec pre-set keys in parent class
      @target = Target.new options[:target]
      @lenient = options[:lenient] if options.key?(:lenient)
    end

    def configure source = nil, options = {}, &block

      if source.kind_of? Hash
        configure_from_hash source, options
      elsif source.kind_of? String
        configure_from_file source, options
      elsif source
        configure_from_object source, options
      end

      instance_exec self, &block if block

      @target.object
    end

    private

    def configure_from_hash h, options = {}
      h.each_pair do |k,v|
        raise KeyError, k unless @keys.empty? or @keys.include?(k.to_sym) or @lenient
        @target.set k, v if @keys.empty? or @keys.include?(k.to_sym)
      end
    end

    def configure_from_file f, options = {}
      args = [ File.open(f, 'r').read, f ]
      args << options[:lineno] if options[:lineno]
      instance_eval *args
    end

    def configure_from_object o, options = {}
      @keys.each{ |key| @target.set key, o.send(key.to_sym) if o.respond_to? key.to_sym }
    end

    def method_missing name, *args, &block

      m = name.to_s.match(/\A(\w+)\=?\Z/)

      # TODO: fail if property is not in @keys
      key = m[1]
      if key
        raise KeyError, key unless @target.has?(key) or @lenient
        return @target.get key if args.empty?
        raise KeyError, key unless @keys.empty? or @keys.include?(key.to_sym) or @lenient
        @target.set key, args.first if @keys.empty? or @keys.include?(key.to_sym)
      else
        super
      end
    end
  end
end
