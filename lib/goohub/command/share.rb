# coding: utf-8
require 'json'
require 'uri'
require 'yaml'
require 'mail'
require 'net/https'

class GoohubCLI < Clian::Cli
  desc "share CALENDAR_ID EVENT_ID FUNNEL_NAME", "Sharing calendar(CALENDAR_ID) of event(EVENT_ID) by funnel(FUNNEL_NAME)"
  long_desc <<-LONGDESC
CALENDAR_ID and EVENT_Id is detected by events command

You can change kind of sharing by making funnel

You can make funnel by write command, and then you can set FUNNEL_NAME
LONGDESC

  def share(calendar_id, event_id, funnel_name)
    google_event = client.get_event(calendar_id, event_id)
    e = parse_event(google_event)
  end

  private

  def parse_event(event)
    e = Goohub::Resource::Event.new(event)
    e.dtstart = event.start.date_time
    e.dtend = event.end.date_time
    return e
  end
end# class GoohubCLI
