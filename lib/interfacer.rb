##
#
# Interfacer should be mixed into objects that need to behave in a few
# differnt ways based on what it is interacting with.
#
# class ITest
#   include Interfacer
#
#   with_interface(:foo) do
#     def my_method
#       "called for foo"
#     end
#   end
#
#   def my_method
#     "called globally"
#   end
# end
#
# i = ITest.new
# i.my_method #=> "called globally"
# i.with_interface(:foo) do
#   i.my_method #=> "called for foo"
# end
# i.my_method #=> "called globally"
#
module Interfacer

  def self.included kls
    kls.extend ClassMethods
  end

  def with_interface name
    activate_interface(name)
    yield
    deactivate_interface(name)
  end

  def activate_interface name
    proc_with_methods = get_proc_with_methods_for_interface(name)

    obj = mix_object(Object.new, proc_with_methods)
    alias_previously_defined_methods_in_list( obj.methods(false) )

    mix_object(self, proc_with_methods)
  end

  def get_proc_with_methods_for_interface name
    proc_with_methods = self.class.interfaces[name.to_sym]
  end

  def mix_object(inst, defining_proc)
    (class << inst ; self ; end).class_eval &defining_proc
    inst
  end

  def alias_previously_defined_methods_in_list method_list
    slapclass = (class << self ; self ; end)
    method_list.select{|x| respond_to?(x)}.each do |x|
      if_meth = "interfacer:#{x}"
      if methods.include?(if_meth)
        raise "Don't use interface inside an interface"
      end
      slapclass.send :alias_method, if_meth, x
    end
  end

  def deactivate_interface name
    proc_with_methods = get_proc_with_methods_for_interface(name)

    obj = mix_object(Object.new, proc_with_methods)
    all_methods = obj.methods(false)

    moved = obj.methods(false).select{|x| respond_to?("interfacer:#{x}")}
    to_remove = all_methods - moved
    
    unalias_methods(moved)
    remove_methods(to_remove)
  end

  def unalias_methods methods
    slapclass = class << self ; self ; end
    methods.each do |meth|
      slapclass.send :remove_method, meth
      slapclass.send :alias_method, meth, "interfacer:#{meth}"
    end
  end

  def remove_methods methods
    slapclass = class << self ; self ; end
    methods.each do |meth|
      slapclass.send :remove_method, meth
    end
  end

  module ClassMethods

    def interfaces
      @interfaces
    end

    def with_interface if_name, &blk
      if_name = if_name.to_sym

      @interfaces ||= {}
      @interfaces[if_name] = blk
    end

  end

end
