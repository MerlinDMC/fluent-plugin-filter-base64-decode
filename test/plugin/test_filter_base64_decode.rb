require_relative '../test_helper'

class Base64DecodeFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    @time = Fluent::Engine.now
  end

  CONFIG = %[
    fields field1,field2
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::FilterTestDriver.new(Fluent::Base64DecodeFilter).configure(conf, true)
  end

  def emit(config, record)
    d = create_driver(config)
    d.run {
      d.emit(record, @time)
    }.filtered
  end

  test 'configure' do
    d = create_driver(CONFIG)
    assert_equal ['field1', 'field2'], d.instance.fields
  end

  test 'decode' do
    es = emit(CONFIG, {
                'field1' => "T0s=",
                'field3' => "T0s="
              })

    es.each { |time, record|
      assert_equal 'OK', record['field1']
      assert_equal 'T0s=', record['field3']
      assert_equal false, record.has_key?('field2')
    }
  end

end
