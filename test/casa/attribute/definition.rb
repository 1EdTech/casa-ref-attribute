require 'test/unit'
require 'casa/attribute/definition'

module CASA
  module Attribute
    class Test < Definition

      uuid '0307bb8a-62ef-11e3-bf13-d231feb1dc81'
      section 'use'

      in_squash do |payload|
        'squash'
      end

      in_filter do |payload|
        true
      end

      in_transform do |payload|
        'in_transform'
      end

      out_transform do |payload|
        'out_transform'
      end

      out_filter do |payload|
        true
      end

    end
  end
end

module CASA
  module Attribute
    class TestWithHandlers < Definition

      class Handler
        def initialize definition, options = nil
          @definition = definition
        end
      end
      class SquashHandler < Handler
        def process payload
          'squash'
        end
      end
      class FilterHandler < Handler
        def process payload
          true
        end
      end
      class TransformInHandler < Handler
        def process payload
          'in_transform'
        end
      end
      class TransformOutHandler < Handler
        def process payload
          'out_transform'
        end
      end

      uuid '0307bb8a-62ef-11e3-bf13-d231feb1dc82'
      section 'use'

      in_squash SquashHandler
      in_filter FilterHandler
      in_transform TransformInHandler
      out_transform TransformOutHandler
      out_filter FilterHandler

    end
  end
end

module CASA
  module Attribute
    class TestWithAliases < Definition

      uuid '0307bb8a-62ef-11e3-bf13-d231feb1dc81'
      section 'use'

      squash do |payload|
        'squash'
      end

      filter do |payload|
        true
      end

      transform do |payload|
        'transform'
      end

    end
  end
end



class TestCASAAttributeDefinition < Test::Unit::TestCase

  def test_uuid

    uuid = CASA::Attribute::Test.uuid

    CASA::Attribute::Test.uuid '5eceb84c-62ef-11e3-bf13-d231feb1dc81'
    assert CASA::Attribute::Test.uuid == '5eceb84c-62ef-11e3-bf13-d231feb1dc81'
    assert CASA::Attribute::Test.new('attr').uuid == '5eceb84c-62ef-11e3-bf13-d231feb1dc81'

    CASA::Attribute::Test.uuid uuid
    assert uuid == '0307bb8a-62ef-11e3-bf13-d231feb1dc81'
    assert CASA::Attribute::Test.new('attr').uuid == uuid

  end

  def test_section

    section = CASA::Attribute::Test.section

    CASA::Attribute::Test.section 'require'
    assert CASA::Attribute::Test.section == 'require'
    assert CASA::Attribute::Test.new('attr').section == 'require'

    CASA::Attribute::Test.section 'use'
    assert CASA::Attribute::Test.section == 'use'
    assert CASA::Attribute::Test.new('attr').section == section

  end

  def test_name

    assert CASA::Attribute::Test.new('attr').name == 'attr'

  end

  def test_options

    assert CASA::Attribute::Test.new('attr', {'test'=>'text'}).options['test'] = 'text'

  end

  def test_in_squash

    # get original proc to restore at end
    proc = CASA::Attribute::Test.in_squash

    # test that behavior defined in class definition propagates
    attr = CASA::Attribute::Test.new('attr')
    assert attr.in_squash({}) == 'squash'

    attr = CASA::Attribute::TestWithHandlers.new('attr')
    assert attr.in_squash({}) == 'squash'

    # test passing of Proc
    CASA::Attribute::Test.in_squash Proc.new { |payload| payload['text'] }
    attr = CASA::Attribute::Test.new('attr')
    assert attr.in_squash({'text'=>'test'}) == 'test'

    # test passing of block
    CASA::Attribute::Test.in_squash do |payload|
      payload['text2']
    end
    attr = CASA::Attribute::Test.new('attr')
    assert attr.in_squash({'text2'=>'test2'}) == 'test2'

    # test restore was successful
    CASA::Attribute::Test.in_squash proc
    attr = CASA::Attribute::Test.new('attr')
    assert attr.in_squash({}) == 'squash'

  end

  def test_filter_in

    _test_filter 'in'

  end

  def test_filter_out

    _test_filter 'out'

  end

  def test_transform_in

    _test_transform 'in'

  end

  def test_transform_out

    _test_transform 'out'

  end

  def test_class_attribute_support

    name = 'attrtest'
    class_var_name = CASA::Attribute::Definition.attribute_class_var_name name

    assert class_var_name.is_a? Symbol
    assert class_var_name == "@@attribute_#{name}".to_sym
    assert !CASA::Attribute::Definition.class_variable_defined?(class_var_name)
    assert !CASA::Attribute::Definition.respond_to?(name)
    assert !CASA::Attribute::Definition.new('test').respond_to?(name)

    assert CASA::Attribute::Definition.respond_to?(:support_attribute)
    CASA::Attribute::Definition.support_attribute name

    assert CASA::Attribute::Definition.class_variable_defined?(class_var_name)
    assert CASA::Attribute::Definition.respond_to?(name)
    assert CASA::Attribute::Definition.new('test').respond_to?(name)

    CASA::Attribute::Test.send(name.to_sym, 'testing')
    assert CASA::Attribute::Test.send(name.to_sym) == 'testing'
    assert CASA::Attribute::Test.new('attr').send(name.to_sym) == 'testing'

  end

  def test_class_operation_support

    name = 'opertest'
    class_var_name = CASA::Attribute::Definition.operation_class_var_name name

    assert class_var_name.is_a? Symbol
    assert class_var_name == "@@operation_#{name}".to_sym
    assert !CASA::Attribute::Definition.class_variable_defined?(class_var_name)
    assert !CASA::Attribute::Definition.respond_to?(name)
    assert !CASA::Attribute::Definition.new('test').respond_to?(name)

    assert CASA::Attribute::Definition.respond_to?(:support_operation)
    CASA::Attribute::Definition.support_operation name

    assert CASA::Attribute::Definition.class_variable_defined?(class_var_name)
    assert CASA::Attribute::Definition.respond_to?(name)
    assert CASA::Attribute::Definition.new('test').respond_to?(name)

    CASA::Attribute::Test.send(name.to_sym) do |payload|
      payload['value2']
    end
    attr = CASA::Attribute::Test.new('attr')
    assert attr.send(name.to_sym, {'value2'=>false}) == false
    assert attr.send(name.to_sym, {'value2'=>true}) == true

  end

  def test_class_operation_alias_support

    alias_name = 'operAlias'
    aliased_names = ['operAliased1','operAliased2']

    aliased_names.each { |name| CASA::Attribute::Definition.support_operation name }
    CASA::Attribute::Definition.support_operation_alias alias_name, aliased_names

    CASA::Attribute::Test.send(alias_name.to_sym) do |payload|
      payload['value3']
    end

    attr = CASA::Attribute::Test.new('attr')
    aliased_names.each do |name|
      assert attr.send(name.to_sym, {'value3'=>false}) == false
      assert attr.send(name.to_sym, {'value3'=>true}) == true
    end

  end

  private

  def _test_transform dir

    str = "#{dir}_transform"
    method = str.to_sym

    # get original proc to restore at end
    proc = CASA::Attribute::Test.send(method)

    # test that behavior defined in class definition propagates
    attr = CASA::Attribute::Test.new('attr')
    assert attr.send(method, {}) == str

    attr = CASA::Attribute::TestWithHandlers.new('attr')
    assert attr.send(method, {}) == str

    # test passing of Proc
    CASA::Attribute::Test.send(method, Proc.new { |payload| payload['text'] })
    attr = CASA::Attribute::Test.new('attr')
    assert attr.send(method, {'text'=>'test'}) == 'test'

    # test passing of block
    CASA::Attribute::Test.send(method) do |payload|
      payload['text2']
    end
    attr = CASA::Attribute::Test.new('attr')
    assert attr.send(method, {'text2'=>'test2'}) == 'test2'

    # test restore was successful
    CASA::Attribute::Test.send(method, proc)
    attr = CASA::Attribute::Test.new('attr')
    assert attr.send(method, {}) == str

  end

  def _test_filter dir

    method = "#{dir}_filter".to_sym

    # get original proc to restore at end
    proc = CASA::Attribute::Test.send(method)

    # test that behavior defined in class definition propagates
    attr = CASA::Attribute::Test.new('attr')
    assert attr.send(method, {}) == true

    attr = CASA::Attribute::TestWithHandlers.new('attr')
    assert attr.send(method, {}) == true

    # test passing of Proc
    CASA::Attribute::Test.send(method, Proc.new { |payload| payload['value'] })
    attr = CASA::Attribute::Test.new('attr')
    assert attr.send(method, {'value'=>false}) == false
    assert attr.send(method, {'value'=>true}) == true

    # test passing of block
    CASA::Attribute::Test.send(method) do |payload|
      payload['value2']
    end
    attr = CASA::Attribute::Test.new('attr')
    assert attr.send(method, {'value2'=>false}) == false
    assert attr.send(method, {'value2'=>true}) == true

    # test restore was successful
    CASA::Attribute::Test.send(method, proc)
    attr = CASA::Attribute::Test.new('attr')
    assert attr.send(method, {}) == true
  end

end