
module Mutaconf

  class DSL
    attr_accessor :lenient

    def initialize options = {}

      @attr_targets = {}
      @proxy_targets = {}
      @lenient = options[:lenient] if options.key?(:lenient)

      if options[:attrs]
        options[:attrs].each_pair do |target,attrs|
          if !!attrs == attrs
            @attr_targets.default = Target.new target
          else
            [ attrs ].flatten.each do |attr|
              if !!attr == attr
                @attr_targets.default = Target.new target
              else
                @attr_targets[attr] = Target.new target
              end
            end
          end
        end
      end

      if options[:proxy]
        options[:proxy].each_pair do |target,attrs|
          if !!attrs == attrs
            @proxy_targets.default = target
          else
            [ attrs ].flatten.each do |attr|
              if !!attr == attr
                @proxy_targets.default = target
              else
                @proxy_targets[attr] = target
              end
            end
          end
        end
      end
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

      self
    end

    private

    def configure_from_hash h, options = {}
      h.each_pair{ |attr,value| send attr, value }
    end

    def configure_from_file f, options = {}
      args = [ File.open(f, 'r').read, f ]
      args << options[:lineno] if options[:lineno]
      instance_eval *args
    end

    def configure_from_object o, options = {}
      @attr_targets.each_pair do |attr,target|
        send attr, o.send(attr.to_sym) if o.respond_to? attr.to_sym
      end
    end

    def has? attr, method
      @attr_targets.default or @attr_targets.key?(attr) or @proxy_targets.default or @proxy_targets.key?(method)
    end

    def set attr, value

    end

    def method_missing name, *args, &block

      m = name.to_s.match(/\A(\w+)\=?\Z/)

      attr, method = m[1].to_sym, m[0].to_sym
      if attr
        raise KeyError, attr unless has?(attr, method) or @lenient
        return @attr_targets[attr].get attr if args.empty?
        @attr_targets[attr].set attr, args.first if @attr_targets.default or @attr_targets.key?(attr)
        @proxy_targets[attr].send *(args.unshift method) if @proxy_targets.default or @proxy_targets.key?(attr)
      else
        super
      end
    end
  end
end
