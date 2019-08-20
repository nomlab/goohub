# coding: utf-8
require 'time'
require_relative 'expression'
require_relative 'parser'

################################################################
# Event(for test)
################################################################
class Event
  attr_accessor :summary, :location, :description, :dtstart, :dtend

  def initialize(summary, location, description, dtstart, dtend)
    @summary = summary
    @location = location
    @description = description
    @dtstart = dtstart
    @dtend = dtend
  end

  def put_items
    puts "summary:#{@summary}"
    puts "description:#{@description}"
    puts "location:#{@location}"
    puts "dtstart:#{@dtstart}"
    puts "dtend:#{@dtend}"
  end
end

################################################################
# main
################################################################
#expr = Parser.evaluate('dtstart:11-11 .. 12-12') #TODO
e = Event.new("就活，web面談", "location", "description", Time.new(2018, 8, 6, 15, 30, 0, "+09:00"), Time.new(2018, 8, 6, 19, 30, 0, "+09:00"))
#expr = FilterParser.evaluate("summary:就活")
expr = FilterParser.evaluate("dtstart: after : 2018-12-1")
if  expr.evaluate(e) then
  expr = ActionParser.evaluate('replace:summary:{#}（山本）& hide:description' ) #TODO
end
p "result: " + "#{expr.evaluate(e)}"# for debug
e.put_items
# expr = OutletParser.evaluate("google_calendar:kjtbw1219@gmail.com")
# expr.evaluate(e)
