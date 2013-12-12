require 'test/unit'
require 'casa-attribute/loader'
require 'casa-attribute/loader_attribute_error'
require 'casa-attribute/loader_class_error'
require 'casa-attribute/loader_file_error'

class TestCASAAttributeLoader < Test::Unit::TestCase

  def test_load!

    assert CASA::Attribute::Loader.loaded.size == 0

    assert_nothing_raised do
      CASA::Attribute::Loader.load! 'class' => 'CASA::Attribute::Definition', 'name' => 'definition'
    end
    assert CASA::Attribute::Loader.loaded.size == 1
    assert CASA::Attribute::Loader.loaded['definition'].class.name == 'CASA::Attribute::Definition'

    assert_raise CASA::Attribute::LoaderAttributeError do
      CASA::Attribute::Loader.load! 'class' => 'CASA::Attribute::Fail'
    end

    assert_raise CASA::Attribute::LoaderAttributeError do
      CASA::Attribute::Loader.load! 'name' => 'fail'
    end

    assert_raise CASA::Attribute::LoaderFileError do
      CASA::Attribute::Loader.load! 'class' => 'CASA::Attribute::Fail', 'name' => 'fail', 'path' => 'does/not/exist'
    end

    begin
      CASA::Attribute::Loader.load! 'class' => 'CASA::Attribute::Fail', 'name' => 'fail', 'path' => 'does/not/exist'
    rescue CASA::Attribute::LoaderFileError => e
      assert e.class_name == 'CASA::Attribute::Fail'
      assert e.require_path == 'does/not/exist'
    end

    assert_raise CASA::Attribute::LoaderClassError do
      CASA::Attribute::Loader.load! 'class' => 'CASA::Attribute::Fail', 'name' => 'fail', 'path' => 'casa-attribute/definition'
    end

    begin
      CASA::Attribute::Loader.load! 'class' => 'CASA::Attribute::Fail', 'name' => 'fail', 'path' => 'casa-attribute/definition'
    rescue CASA::Attribute::LoaderClassError => e
      assert e.class_name == 'CASA::Attribute::Fail'
      assert e.require_path == 'casa-attribute/definition'
    end

  end

end
