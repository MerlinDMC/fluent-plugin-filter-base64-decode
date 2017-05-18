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
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::Base64DecodeFilter).configure(conf)
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
    d = create_driver(CONFIG)
    record = {
      'field1' => "T0s=",
      'field3' => "T0s="
    }
    d.run(default_tag: "test") do
      d.feed(record)
    end

    filtered_records = d.filtered_records
    assert_equal(1, filtered_records.size)
    record = filtered_records[0]
    assert_equal 'OK', record['field1']
    assert_equal 'T0s=', record['field3']
    assert_equal false, record.has_key?('field2')
  end
end
