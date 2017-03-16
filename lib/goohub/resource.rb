require 'forwardable'

module Goohub
  module Resource
    class Base
      extend Forwardable

      def initialize(raw_resource)
        @raw_resource = raw_resource
      end
    end # class Base

    dir = File.dirname(__FILE__) + "/resource"

    autoload :Event,             "#{dir}/event.rb"
    autoload :Calendar,          "#{dir}/calendar.rb"
  end # module Resource
end # module Goohub
