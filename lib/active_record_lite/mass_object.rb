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
end

# def self.my_attr_accessible(*attributes)
#     # convert to array of symbols in case the user gives you strings.
#     @attributes = attributes.map { |attr_name| attr_name.to_sym }
#
#     attributes.each do |attribute|
#       # add setter/getter methods
#       attr_accessor attribute
#     end
#   end
#
#   def self.attributes
#     @attributes
#   end
#
#
#
#   def initialize(params = {})
#       params.each do |attr_name, value|
#         attr_name = attr_name.to_sym
#
#         p self
#         p self.class
#         p @attributes
#
#
#         if self.class.attributes.include?(attr_name)
#           self.send("#{attr_name}=", value)
#         else
#           raise "mass assignment to unregistered attribute #{attr_name}"
#         end
#       end
#     end
#   end
#
#

