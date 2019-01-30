################################################################
# Abstract Parser
################################################################
module Goohub
  module Parser
    class Base
      def self.evaluate(query, upper_expression = nil)
        # in case of  upper_expression is terminal expression
        return self.evaluate(upper_expression) if query == "" and upper_expression != nil
        p "query: " + query # for debug
        p "upper_expression: " + upper_expression if upper_expression != nil # for debug
        query.gsub!(" ", "")

        query_array = query.partition(/\(|!|&|\|/)
        # in case of "(expression) & or | expression" pattern
        query_array[0] = upper_expression if upper_expression != nil
        return determine_non_terminal_expression(query_array) if determine_non_terminal_expression(query_array)

        query_array = query.partition(":")
        return determine_terminal_expression(query_array) if determine_terminal_expression(query_array)
      end

      private

      def self.determine_non_terminal_expression(query_array)
        case query_array[1]
        when "\(" then
          query_array = query_array[2].partition(/\)/)
          return self.evaluate(query_array[2], upper_expression = query_array[0])
        when "&" then
          expression1 = self.evaluate(query_array[0])
          expression2 = self.evaluate(query_array[2])
          return Goohub::Expression::And.new(expression1, expression2)
        when "|" then
          expression1 = self.evaluate(query_array[0])
          expression2 = self.evaluate(query_array[2])
          return Goohub::Expression::Or.new(expression1, expression2)
        when "!" then
          return Goohub::Expression::Not.new(self.evaluate(query_array[2]))
        else
          return nil
        end
      end

      def self.determine_terminal_expression(query_array)
        puts "Not implemented"
      end
    end


    ################################################################
    # Filter Parser
    ################################################################
    class Filter < Base

      def self.evaluate(query, upper_expression = nil)
        #        Parser.evaluate(query, upper_expression = nil)
        super
      end

      private

      def self.determine_non_terminal_expression(query_array)
        super
      end

      def self.determine_terminal_expression(query_array)
        p "#{query_array}"
        case query_array[0]
        when "summary" then
          node = Goohub::Expression::Summary.new(query_array[2])
        when "location" then
          node = Goohub::Expression::Location.new(query_array[2])
        when "description" then
          node = Goohub::Expression::Description.new(query_array[2])
        when "dtstart" then
          node = Goohub::Expression::Dtstart.new(query_array[2])
        when "dtend" then
          node = Goohub::Expression::Dtend.new(query_array[2])
        else
          return nil
        end
      end

    end# class FilterParser

    ################################################################
    # Action Parser
    ################################################################
    class Action < Base
      def self.evaluate(query, upper_expression = nil)
        super
      end

      private

      def self.determine_non_terminal_expression(query_array)
        super
      end

      def self.determine_terminal_expression(query_array)
        case query_array[0]
        when "hide_event" then
          node = Goohub::Expression::Hide_event.new
        when "hide" then
          node = Goohub::Expression::Hide.new(query_array[2])
        when "replace" then
          query_array = query_array[2].partition(":")
          node = Goohub::Expression::Replace.new(query_array[0], query_array[2])
        else
          return nil
        end
      end
    end

    ################################################################
    # Outlet Parser
    ################################################################
    class Outlet < Base
      def self.evaluate(query, upper_expression = nil)
        super
      end

      private

      def self.determine_non_terminal_expression(query_array)
        super
      end

      def self.determine_terminal_expression(query_array)
        case query_array[0]
        when "google_calendar" then
          node = Goohub::Expression::Google_calendar.new(query_array[2])
        when "mail" then
          node = Goohub::Expression::Mailer.new(query_array[2])
        when "slack" then
          node = Goohub::Expression::Slack.new
        when "stdout" then
          node = Goohub::Expression::Stdout.new
        else
          return nil
        end
      end
    end# class Outlet
  end# module Parser
end# module Goohub
