module Goohub
  module DateFrame
    class Base
      def initialize(start_date)
        year_month = start_date.split('-')
        @start_date = DateTime.new(year_month[0].to_i, year_month[1].to_i)
        rewind
        forward
      end

      def each_to(date)
        year_month = date.split('-')
        end_date = DateTime.new(year_month[0].to_i, year_month[1].to_i)
        loop do
          start = self.peek_start
          break if start > end_date
          frames = [start, self.peek_end]
          yield frames
          start = self.next
        end
      end

      def next(cycles = 1)
        frame = @frame_start
        @frame_start = next_frame_start(cycles)
        @frame_end = next_frame_end(cycles)

        return frame
      end

      def peek_start
        @frame_start
      end

      def peek_end
        @frame_end
      end

      def rewind
        @frame_start = beginning_of_frame(@start_date)
        return self
      end

      def forward
        @frame_end = ending_of_frame(@start_date)
        return self
      end

      private

      def next_frame_start(cycles = 1)
        raise "should be defined in subclasses"
      end

      def beginning_of_frame(date)
        raise "should be defined in subclasses"
      end

      def ending_of_frame(date)
        raise "should be defined in subclasses"
      end

      def frames_between(date1, date2)
        raise "should be defined in subclasses"
      end

    end # class Base

    class Monthly < Base
      private

      def next_frame_start(cycles = 1)
        @frame_start >> cycles
      end

      def next_frame_end(cycles = 1)
        @frame_end >> cycles
      end

      def beginning_of_frame(date)
        date.class.new(date.year, date.month, 1)
      end

      def ending_of_frame(date)
        date.next_month - Rational(1, 24 * 60 * 60)
      end

    end # class Monthly
  end # module DateFrame
end # module Goohub
