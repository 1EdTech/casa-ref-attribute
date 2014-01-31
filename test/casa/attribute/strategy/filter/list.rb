require 'test/unit'
require 'casa/attribute/loader'
require 'casa/attribute/strategy/filter/list'

class TestCASAAttributeStrategyFilterList < Test::Unit::TestCase

  def test_filter

    # Setup an attribute mock
    CASA::Attribute::Loader.load! 'class' => 'CASA::Attribute::Definition', 'name' => 'attr'
    attr = CASA::Attribute::Loader.loaded['attr']
    attr.class.section 'use'

    assert CASA::Attribute::Strategy::Filter::List.new(attr, {

    }).process({
      'attributes' => {
        'use' => {
          'attr' => 'foobar'
        }
      }
    })

    assert CASA::Attribute::Strategy::Filter::List.new(attr, {
      'blacklist' => []
    }).process({
      'attributes' => {
        'use' => {
          'attr' => 'foobar'
        }
      }
    })

    # direct string match
    assert !CASA::Attribute::Strategy::Filter::List.new(attr, {
      'blacklist' => [
        'foobar'
      ]
    }).process({
      'attributes' => {
        'use' => {
          'attr' => 'foobar'
        }
      }
    })

    # regex match
    assert !CASA::Attribute::Strategy::Filter::List.new(attr, {
      'blacklist' => [
        '/ooba/'
      ]
    }).process({
      'attributes' => {
        'use' => {
          'attr' => 'foobar'
        }
      }
    })

    # direct string no match
    assert CASA::Attribute::Strategy::Filter::List.new(attr, {
      'blacklist' => [
        'ooba'
      ]
    }).process({
      'attributes' => {
        'use' => {
          'attr' => 'foobar'
        }
      }
    })

    # regex match
    assert !CASA::Attribute::Strategy::Filter::List.new(attr, {
      'blacklist' => [
        '/.*bar$/'
      ]
    }).process({
      'attributes' => {
        'use' => {
          'attr' => 'foobar'
        }
      }
    })

  end

end