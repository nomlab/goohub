module Goohub
  module Resource
    class CalendarCollection < Collection
      def each
        @raw_resources.items.each do |e|
          yield Goohub::Resource::Calendar.new(e)
        end
      end

      def dump
        @raw_resources
      end
    end # class EventCollection
  end # module Resource
end # module Goohub
