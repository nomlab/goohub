require 'json'
require 'uri'
require 'yaml'
require 'net/https'

class GoohubCLI < Clian::Cli
  desc "share CALENDAR_ID EVENT_ID FILTER ACTION", "Filtering event by EVENT_ID, and share it by action"
  long_desc <<-LONGDESC
FILTER is `no_filter`, `summary_delete`, `created_delete`, or `location_delete` (default is `no_filter`)

ACTION is `stdout`, `calendar:POST_CALENDAR_ID`, or `slack` (default is `stdout`)

If you use `slack` in ACTION, you need get incoming-webhook url and set it in settings.yml
LONGDESC

  def share(calendar_id, event_id, filter = "no_filter", action = "stdout")
    @incoming_webhook = ""
    @sentence_items = {}
    @sentence = ""
    @event = client.get_event(calendar_id, event_id)
    set_incoming_webhook_url
    make_default_sentence_items
    apply_filter(filter)
    make_sentence
    apply_action(action)
  end

  private

  def set_incoming_webhook_url
    settings_file_path = "settings.yml"
    config = YAML.load_file(settings_file_path) if File.exist?(settings_file_path)
    @incoming_webhook = ENV['INCOMING_WEBHOOK_URL'] || config["incoming_webhook_url"]
  end

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
    return if filter == "no_filter"
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
    post_slack(@sentence) if action == "slack"
    post_calendar(action.partition(":")[2]) if action.include?("calendar")
  end

  def post_slack(string, options = {})
    payload = options.merge({text: string})
    uri = URI.parse(@incoming_webhook)
    res = nil
    json = payload.to_json
    request = "payload=" + json

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = http.post(uri.request_uri, request)
    end
    puts "Slack post is end, post content is under"
    puts  @sentence
    return res
  end

  def post_calendar(calendar_id)
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
