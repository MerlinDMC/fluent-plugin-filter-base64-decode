# encoding: utf-8
require 'base64'

require 'fluent/plugin/filter'

module Fluent::Plugin
  class Base64DecodeFilter < Fluent::Plugin::Filter
    Fluent::Plugin.register_filter('base64_decode', self)

    config_param :fields, :array, value_type: :string

    def filter(tag, time, record)
      @fields.each { |key|
        record[key] = Base64.decode64(record[key]) if record.has_key? key
      }
      record
    end

  end if defined?(Filter) # Support only >= v0.12
end
