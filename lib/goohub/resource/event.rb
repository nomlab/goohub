module Goohub
  module Resource
    class Event < Base

      def_delegators :@raw_resource,
      :id,
      :summary,
      :location,
      :description

      attr_accessor :dtstart, :dtend

      def dump
        @raw_resource
      end
    end # class Event
  end # module Resource
end # module Goohub
