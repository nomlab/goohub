module Goohub
  module Resource
    class Event < Base

      def_delegators :@raw_resource,
      :id,
      :summary

      def dump
        @raw_resource
      end
    end # class Event
  end # module Resource
end # module Goohub
