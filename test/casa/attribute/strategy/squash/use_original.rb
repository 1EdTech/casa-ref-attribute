require 'test/unit'
require 'casa/attribute/loader'
require 'casa/attribute/strategy/squash/use_latest'

class TestCASAAttributeStrategySquashUseOriginal < Test::Unit::TestCase

  def test_use_original

    # Setup an attribute mock
    CASA::Attribute::Loader.load! 'class' => 'CASA::Attribute::Definition', 'name' => 'attr'
    attr = CASA::Attribute::Loader.loaded['attr']
    attr.class.section 'use'

    handler = CASA::Attribute::Strategy::Squash::UseOriginal.new attr

    payload = {
      'original' => {
        'use' => {
          'attr' => 'a'
        }
      }
    }

    assert 'a' == handler.process(payload)

    payload = {
      'original' => {
        'use' => {
          'attr' => 'a'
        }
      },
      'journal' => [
        {
          'use' => {
            'attr' => 'b'
          }
        }
      ]
    }

    assert 'a' == handler.process(payload)

    payload = {
      'original' => {
        'use' => {
          'attr' => 'a'
        }
      },
      'journal' => [
        {
          'use' => {
            'attr' => 'b'
          }
        },
        {
          'use' => {
            'attr' => 'c'
          }
        }
      ]
    }

    assert 'a' == handler.process(payload)

  end

end