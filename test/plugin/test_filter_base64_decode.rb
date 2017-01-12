require_relative '../test_helper'

class Base64DecodeFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    @type base64_decode
    fields field1,field2
  ]

  def create_driver(conf=CONFIG, tag='test', use_v1=true)
    Fluent::Test::FilterTestDriver.new(Fluent::Base64DecodeFilter, tag).configure(conf, use_v1)
  end

  def test_configure
    d = create_driver(CONFIG)
    assert_equal [:field1, :field2], d.instance.fields
  end

  def test_decode
    d = create_driver(CONFIG)
    d.run do
      d.emit({
        "field1": "T0s=",
        "field3": "T0s="
      })
    end

    emits = d.emits

    assert_equal 1, emits.length
    assert_equal 'test', emits[0][0] # tag

    record = emits[0][2]

    assert_equal 'OK', record[:field1]
    assert_equal 'T0s=', record[:field3]
    assert_equal false, record.has_key?(:field2)
  end

end
