require 'json'
require 'uri'
require 'yaml'
require 'net/https'

class GoohubCLI < Clian::Cli
  desc "share CALENDAR_ID EVENT_ID FILTER ACTION", "Filtering event by EVENT_ID, and share it by action"

  def share(calendar_id, event_id, filter = "location_delete", action = "stdout")
    @sentence_items = {}
    @sentence = ""
    @event = client.get_event(calendar_id, event_id)
    make_default_sentence_items
    apply_filter(filter)
    make_sentence
    apply_action(action)
  end

  private

  def make_default_sentence_items
    @sentence_items["summary"] =    @event.summary
    @sentence_items["id"] =         @event.id
    @sentence_items["created"] =    @event.created
    @sentence_items["kind"] =       @event.kind
    @sentence_items["organized"] =  @event.organizer.display_name
    @sentence_items["start_time"] = @event.start.date_time
    @sentence_items["end_time"] =   @event.end.date_time
    @sentence_items["location"] =   @event.location
  end

  def apply_filter(filter)
    @sentence_items["location"] = nil if filter == "location_delete"
    @sentence_items["created"] = nil if filter == "created_delete"
    @sentence_items["summary"] = nil if filter == "summary_delete"
  end

  def make_sentence
    @sentence_items.each{ |key, value|
      item_name = "#{key}:"
      # This while is need to align indent
      while item_name.length < 17
        item_name << " "
      end
      @sentence <<  item_name + "#{value}" + "\n"
    }
  end

  def apply_action(action)
    puts @sentence if action == "stdout"
    post_message(@sentence) if action == "slack"
    post_event(action.partition(":")[2]) if action.include?("calendar")
  end


  def post_event(calendar_id)
    event =
      Google::Apis::CalendarV3::Event.new({
                                            summary: @sentence_items["summary"],
                                            start: {
                                              date_time: @sentence_items["start_time"],
                                            },
                                            end: {
                                              date_time: @sentence_items["end_time"],
                                            },
                                            location: @sentence_items["location"]
                                          })
    result = client.insert_event(calendar_id, event)
    puts "Event created: #{result.html_link}"
  end
end# class GoohubCLI
