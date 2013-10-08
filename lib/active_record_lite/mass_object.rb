class MassObject


  def initialize args = {}

    @attributes = []

    needs_to_be_converted = args.map {|method_name, value| method_name}
    MassObject.my_attr_accessible(*needs_to_be_converted)

    needs_to_be_converted.each do |method_name|
      instance_variable_set("@#{method_name}", args[method_name])
      @attributes << method_name.to_sym
    end
  end


  def self.my_attr_accessible(*args)

     args.each do |method_name|

       #getter
       define_method(method_name.to_s) do
         instance_variable_get("@#{method_name}")
       end

       #setter
       define_method("#{method_name}=") do |value|
         instance_variable_set("@#{method_name}", value)
       end

       @attrributes = method_name

     end
  end

  def self.attributes
    @attributes
  end
  
  def self.parse_all(results)
    parsed_results = []
    results.each do |result|
      parsed_results << self.new(result)
    end
    parsed_results
  end
  
  
end
