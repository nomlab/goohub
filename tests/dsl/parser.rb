
################################################################
# Abstract Parser
################################################################
class Parser
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
      return And.new(expression1, expression2)
    when "|" then
      expression1 = self.evaluate(query_array[0])
      expression2 = self.evaluate(query_array[2])
      return Or.new(expression1, expression2)
    when "!" then
      return Not.new(self.evaluate(query_array[2]))
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
class FilterParser < Parser
  def self.evaluate(query, upper_expression = nil)
    super
  end

  private

  def self.determine_non_terminal_expression(query_array)
    super
  end

  def self.determine_terminal_expression(query_array)
    case query_array[0]
    when "summary" then
      node = Summary.new(query_array[2])
    when "location" then
      node = Location.new(query_array[2])
    when "description" then
      node = Description.new(query_array[2])
    when "dtstart" then
      node = Dtstart.new(query_array[2])
    when "dtend" then
      node = Dtend.new(query_array[2])
    else
      return nil
    end
  end

end# class FilterParser

################################################################
# Action Parser
################################################################
class ActionParser < Parser
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
      node = Hide_event.new
    when "hide" then
      node = Hide.new(query_array[2])
    when "replace" then
      query_array = query_array[2].partition(":")
      node = Replace.new(query_array[0], query_array[2])
    else
      return nil
    end
  end

end
