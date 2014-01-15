require 'test/unit'
require 'casa/attribute/definition'

module CASA
  module Attribute
    class Test < Definition

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
      class TransformHandler < Handler
        def process payload
          'transform'
        end
      end

      uuid '0307bb8a-62ef-11e3-bf13-d231feb1dc82'
      section 'use'

      squash SquashHandler
      filter FilterHandler
      transform TransformHandler

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

  def test_squash

    # get original proc to restore at end
    proc = CASA::Attribute::Test.squash

    # test that behavior defined in class definition propagates
    attr = CASA::Attribute::Test.new('attr')
    assert attr.squash({}) == 'squash'

    attr = CASA::Attribute::TestWithHandlers.new('attr')
    assert attr.squash({}) == 'squash'

    # test passing of Proc
    CASA::Attribute::Test.squash Proc.new { |payload| payload['text'] }
    attr = CASA::Attribute::Test.new('attr')
    assert attr.squash({'text'=>'test'}) == 'test'

    # test passing of block
    CASA::Attribute::Test.squash do |payload|
      payload['text2']
    end
    attr = CASA::Attribute::Test.new('attr')
    assert attr.squash({'text2'=>'test2'}) == 'test2'

    # test restore was successful
    CASA::Attribute::Test.squash proc
    attr = CASA::Attribute::Test.new('attr')
    assert attr.squash({}) == 'squash'

  end

  def test_filter

    # get original proc to restore at end
    proc = CASA::Attribute::Test.filter

    # test that behavior defined in class definition propagates
    attr = CASA::Attribute::Test.new('attr')
    assert attr.filter({}) == true

    attr = CASA::Attribute::TestWithHandlers.new('attr')
    assert attr.filter({}) == true

    # test passing of Proc
    CASA::Attribute::Test.filter Proc.new { |payload| payload['value'] }
    attr = CASA::Attribute::Test.new('attr')
    assert attr.filter({'value'=>false}) == false
    assert attr.filter({'value'=>true}) == true

    # test passing of block
    CASA::Attribute::Test.filter do |payload|
      payload['value2']
    end
    attr = CASA::Attribute::Test.new('attr')
    assert attr.filter({'value2'=>false}) == false
    assert attr.filter({'value2'=>true}) == true

    # test restore was successful
    CASA::Attribute::Test.filter proc
    attr = CASA::Attribute::Test.new('attr')
    assert attr.filter({}) == true

  end

  def test_transform

    # get original proc to restore at end
    proc = CASA::Attribute::Test.transform

    # test that behavior defined in class definition propagates
    attr = CASA::Attribute::Test.new('attr')
    assert attr.transform({}) == 'transform'

    attr = CASA::Attribute::TestWithHandlers.new('attr')
    assert attr.transform({}) == 'transform'

    # test passing of Proc
    CASA::Attribute::Test.transform Proc.new { |payload| payload['text'] }
    attr = CASA::Attribute::Test.new('attr')
    assert attr.transform({'text'=>'test'}) == 'test'

    # test passing of block
    CASA::Attribute::Test.transform do |payload|
      payload['text2']
    end
    attr = CASA::Attribute::Test.new('attr')
    assert attr.transform({'text2'=>'test2'}) == 'test2'

    # test restore was successful
    CASA::Attribute::Test.transform proc
    attr = CASA::Attribute::Test.new('attr')
    assert attr.transform({}) == 'transform'

  end

end