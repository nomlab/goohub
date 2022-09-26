module Goohub
  module Resource
    class Event < Base

      attr_accessor :id, :summary, :location, :description, :dtstart, :dtend, :sequence
      def initialize(raw_resource)
        @raw_resource = raw_resource
        @id = raw_resource.id
        @summary = raw_resource.summary
        @sequence = raw_resource.sequence
      end

      def dump
        @raw_resource
      end
    end # class Event
  end # module Resource
end # module Goohub
