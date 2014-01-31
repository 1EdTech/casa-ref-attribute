require 'test/unit'
require 'casa/attribute/loader'
require 'casa/attribute/strategy/transform/identity_map'

class TestCASAAttributeStrategyTransformIdentityMap < Test::Unit::TestCase

  def test_filter

    # Setup an attribute mock
    CASA::Attribute::Loader.load! 'class' => 'CASA::Attribute::Definition', 'name' => 'attr'
    attr = CASA::Attribute::Loader.loaded['attr']
    attr.class.section 'use'

    assert CASA::Attribute::Strategy::Transform::IdentityMap.new(attr, {
    }).process({
      'identity' => {
        'id' => 'id1',
        'originator_id' => 'orig1'
      },
      'attributes' => {
        'use' => {
          'attr' => 'foo'
        }
      }
    }) == 'foo'

    assert CASA::Attribute::Strategy::Transform::IdentityMap.new(attr).process({
      'identity' => {
        'id' => 'id1',
        'originator_id' => 'orig1'
      },
      'attributes' => {
        'use' => {
          'attr' => 'foo'
        }
      }
    }) == 'foo'

    assert CASA::Attribute::Strategy::Transform::IdentityMap.new(attr, {
      'id1@orig1' => 'bar'
    }).process({
      'identity' => {
        'id' => 'id1',
        'originator_id' => 'orig1'
      },
      'attributes' => {
        'use' => {
          'attr' => 'foo'
        }
      }
    }) == 'bar'

    assert CASA::Attribute::Strategy::Transform::IdentityMap.new(attr, {
      'idX@orig1' => 'bar'
    }).process({
      'identity' => {
        'id' => 'id1',
        'originator_id' => 'orig1'
      },
      'attributes' => {
        'use' => {
          'attr' => 'foo'
        }
      }
    }) == 'foo'

  end

end