require 'rubygems'
require 'test/spec'
require 'lib/interfacer'

describe 'A class including Interfacer' do
  setup do
    @kls = class ITest ; include Interfacer ; end
  end

  it 'should respond to with_interface on the instance' do
    assert @kls.new.respond_to?(:with_interface)
  end

  it 'should respond to with_interface on the class' do
    assert @kls.respond_to?(:with_interface)
  end
end

describe 'A class with an interface method and no other methods' do
  setup do
    class ITest
      include Interfacer

      with_interface(:foo) do
        def bar
        end
      end
    end
  end

  it 'should not respond to the method in the interface when interface not activated' do
    assert !ITest.new.respond_to?(:bar)
  end

  it 'should respond to the method in the interface after interface activated' do
    inst = ITest.new
    inst.with_interface :foo do
      assert inst.respond_to?(:bar)
    end
  end
end

describe 'A class with an interface that defines a method already in the class' do
  setup do
    class ITest
      include Interfacer

      def bar
        'original'
      end

      with_interface(:foo) do
        def bar
          'baz'
        end
      end
    end
  end

  it 'should call the original method when interface not activated' do
    assert_equal 'original', ITest.new.bar
  end

  it 'should call the interfaced method in with_interface method' do
    inst = ITest.new
    inst.with_interface :foo do
      assert_equal 'baz', inst.bar
    end
  end

  it 'should interface => global => interface again cleanly' do
    inst = ITest.new
    inst.with_interface(:foo) {}
    inst.with_interface(:foo) do
      assert_equal 'baz', inst.bar
    end
  end

end

describe 'A Class with multiple interfaces' do
  setup do
    class ITest
      include Interfacer

      with_interface(:foo) do
        def bar ; 'bar_foo' ; end
      end

      with_interface(:baz) do
        def bar ; 'bar_baz' ; end
      end
    end
  end

  it 'should change at between interfaces cleanly' do
    i = ITest.new
    i.with_interface(:foo) {}
    i.with_interface(:baz) do
      assert_equal 'bar_baz', i.bar
    end
  end

  # So people don't lose their scope and mangle methods
  it 'should not allow activating an interface within an interface' do
    i = ITest.new
    i.with_interface(:foo) do
      assert_raise(RuntimeError) do
        i.with_interface(:baz) {}
      end
    end
  end
end
