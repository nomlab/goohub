# coding: utf-8

################################################################
# Abstract Expression
################################################################

class Expression
  @@reserved_word = ["today", "everyday", "weekday", "holiday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

end

################################################################
#Non-Terminal Expression
################################################################
class Or < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(e)
    result1 = @expression1.evaluate(e)
    result2 = @expression2.evaluate(e)
    return (result1 or result2)
  end
end

class And < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(e)
    result1 = @expression1.evaluate(e)
    result2 = @expression2.evaluate(e)
    return (result1 and result2)
  end
end

class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(e)
    return (not @expression.evaluate(e))
  end
end

################################################################
# Terminal Expression for Filter
################################################################
class EventString < Expression
  def initialize(arg)
    @arg = arg
    @arg = to_regexp(arg) if arg.match(/\/.*\//)
  end

  def evaluate(e)
    str = read(e)
    p "evaluate: " + str + ", #{@arg}"# for debug
    if str[@arg] then
      return true
    else
      return false
    end
  end

  def read(e)
    p "Not implemented"
  end

  def write(e, str)
    p "Not implemented"
  end

  def format_tag(e)
    p "Not implemented"
  end


  private

  def to_regexp(arg)
    return Regexp.new(arg.delete("/"))
  end
end

class Summary < EventString
  def read(e)
    str = e.summary
    return str
  end

  def write(e, str)
    e.summary = str
  end

  def format_tag(e)
    e.summary.gsub!("就活","")
    e.summary.gsub!(/,|，/,"")
  end
end

class Location < EventString
  def read(e)
    return e.location
  end

  def write(e, str)
    e.location = str
  end
end

class Description < EventString
  def read(e)
    return e.description
  end

  def write(e, str)
    e.description = str
  end
end

class EventDate < Expression
  def initialize(arg)
    @arg_type = type(arg)
    @arg = format(arg)
  end

  def evaluate(e)
    date = read(e)
    p "evaluate: " + "#{date}" + ", #{@arg}"# for debug

    case @type
    # TODO
    when :operator then
    when :range then
    when :reserved then
    end

    result = true# for debug
    if result then
      return true
    else
      return false
    end
  end

  private

  def type(arg)
    return :operator if arg.include?(":")
    return :range if arg.include?("..")
    @@reserved_word.each { |word|
      return :reserved if arg == word
    }
  end

  def format(arg)
    case type(arg)
    when :operator then
      arg.gsub!(" ", "")
      array = arg.partition(":")
      # TODO: YYYY-MM-DDは変換できるが，MM-DDは変換不可
      return [array[0], Time.parse(array[2])]

    when :range then
      arg.gsub!(" ", "")
      array = arg.partition("..")
      # TODO: YYYY-MM-DDは変換できるが，MM-DDは変換不可
      return [Time.parse(array[0]), Time.parse(array[2])]
    when :reserved then
      return arg
    end
  end
end# class EventDate

class Dtstart < EventDate
  def read(e)
    return Time.at(e.dtstart)
  end

  def write(e, dtstart)
    e.dtstart = dtstart
  end
end

class Dtend < EventDate
  def read(e)
    return Time.at(e.dtend)
  end

  def write(e, dtend)
    e.dtend = dtend
  end
end


################################################################
# Terminal Expression for Action
################################################################
class Hide_event < Expression
  def evaluate(e)
    return nil
  end
end

class Replace < Expression
  def initialize(event_item, arg=nil)
    @event_item = event_item
    @arg = arg
  end

  def evaluate(e)
    node = FilterParser.determine_terminal_expression([@event_item,"",""])
    @arg = convert_arg(@arg, node.read(e)) if @arg
    node.write(e, @arg)
    node.format_tag(e)
  end

  private

  def convert_arg(arg, str)
    if arg.include?("{#}") then
      arg.gsub!(/\{#\}/, str)
    end
    return arg
  end
end

class Hide < Replace
end

################################################################
# Terminal Expression for Outlet
################################################################
class Google_calendar < Expression
  def initialize(calendar_id)
    @calendar_id= calendar_id
  end

  def evaluate(e)
    puts "Outlet Calendar: #{@calendar_id}"
  end
end

class Mail < Expression
  def initialize(mail_address)
    @mail_address = mail_address
  end

  def evaluate(e)
    puts "Outlet Mail: #{@mail_address}"
  end
end

class Slack < Replace
  def evaluate(e)
    puts "Outlet Slack"
  end
end
