module Goohub
  module Resource
    class Calendar < Base

      def_delegators :@raw_resource,
      :summary,
      :id

      def dump
        @raw_resource
      end
    end # class Calendar
  end # module Resource
end # module Goohub
