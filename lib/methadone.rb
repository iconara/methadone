module Methadone
  module Dsl
    def factory(&definition)
      ctx = FactoryContext.new
      ctx.instance_eval(&definition)
      ctx.build
    end
  end
  
  class Factory
    def initialize(definitions)
      @definitions = definitions
    end
  
    def [](id)
      @definitions[id].instance(self)
    end
  end

  class FactoryContext < BasicObject
    def initialize
      @definitions = {}
    end
  
    def build
      Factory.new(@definitions)
    end
  
    def register(id, cls, args=[], options={})
      @definitions[id] = definition_type(options[:type]).new(cls, args)
    end
  
    def define(*args)
      raise ArgumentError, "Wrong number of arguments (#{args.size} for 1 or 2)" unless args.size == 1 || args.size == 2
      defs = {args.first => args.last} if args.size == 2
      defs = args.first if args.size == 1
      defs.each do |id, value|
        @definitions[id] = LiteralDefinition.new(value)
      end
    end
  
    def method_missing(msg, *args, &block)
      Reference.new(msg)
    end
    
  private
  
    def definition_type(type)
      return PrototypeFactoryDefinition if type == :prototype
      SingletonFactoryDefinition
    end
  end
  
  class Reference
    def initialize(id)
      @id = id
    end
    
    def resolve(factory)
      factory[@id]
    end
  end

  class PrototypeFactoryDefinition
    def initialize(cls, args)
      @cls, @args = cls, args
    end
    
    def instance(factory)
      @cls.new(*resolve_args(factory))
    end
    
    def resolve_args(factory)
      @args.map do |arg|
        case arg
        when Reference then arg.resolve(factory)
        else arg
        end
      end
    end
  end
  
  class SingletonFactoryDefinition < PrototypeFactoryDefinition
    def instance(factory)
      @instance ||= super
    end
  end
  
  class LiteralDefinition
    def initialize(value)
      @instance = value
    end
    
    def instance(factory)
      @instance
    end
  end
end