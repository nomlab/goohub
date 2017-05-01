module Goohub
  module Resource
    class Events < Base

      def_delegators :@raw_resource,
      :to_h


      def dump
        @raw_resource
      end
    end # class Events
  end # module Resource
end # module Goohub
