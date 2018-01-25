# coding: utf-8
require 'json'
require 'uri'
require 'yaml'
require 'mail'
require 'net/https'

class GoohubCLI < Clian::Cli
  desc "share CALENDAR_ID EVENT_ID", "Filtering event by EVENT_ID, and share it by action"
  option :filter, :default => "no_filter", :desc => "specify filter to apply"
  option :action, :default => "stdout", :desc => "specify action to apply"
  long_desc <<-LONGDESC
FILTER is `no_filter`, `summary_delete`, `created_delete`, or `location_delete`

ACTION is `stdout`, `calendar:POST_CALENDAR_ID`, `mail:POST_MAIL_ADDRESS`, or `slack`

If you use `slack` in ACTION, you need get incoming-webhook url and set it in settings.yml

If you use `mail` in ACTION, you need get mail_address and password and set these in settings.yml
LONGDESC

  def share(calendar_id, event_id)
    event = client.get_event(calendar_id, event_id)
    sentence_items = parse_event(event)
    filter = Goohub::Filter.new(options[:filter], sentence_items)
    sentence_items = filter.apply
    action = Goohub::Action.new(options[:action], sentence_items, client)
    action.apply
  end

  private

  def parse_event(event)
    sentence_items = {}
    sentence_items["summary"] =    event.summary
    sentence_items["id"] =         event.id
    sentence_items["created"] =    event.created
    sentence_items["kind"] =       event.kind
    sentence_items["organized"] =  event.organizer.display_name
    sentence_items["start_time"] = event.start.date_time
    sentence_items["end_time"] =   event.end.date_time
    sentence_items["location"] =   event.location
    sentence_items
  end
end# class GoohubCLI
