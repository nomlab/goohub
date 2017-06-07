class GoohubCLI < Clian::Cli
  ################################################################
  # Command: events
  ################################################################
  desc "events CALENDAR_ID START END", "get and store events between START(year-month) and END(year-month) found by CALENDAR_ID"
  option :kvs

  def events(calendar_id, start_m, end_m)
    start = Goohub::DateFrame::Monthly.new(start_date)
    if options[:end]
      end_date = options[:end]
    else
      now = Date.today
      end_date = "#{now.year}-#{now.month}"
    end
    start.each_to(end_date) do |frames|

      min = frames[0].to_s
      max = frames[1].to_s
      params = [calendar_id, frames[0].year.to_s, frames[0].month.to_s]
      puts "Get events of "+ params[1] + "-" + params[2]
      raw_resource = client.list_events(params[0], time_max: max, time_min: min, single_events: true)
      events = Goohub::Resource::EventCollection.new(raw_resource)

      if options[:kvs].nil?
        events.each do |item|
          puts item.summary.to_s + "(" + item.id.to_s + ")"
        end
      else
        puts "Store events to " + options[:kvs]
        print "Status: "
        kvs = Goohub::DataStore.create(options[:kvs].intern)
        puts kvs.store(params.join('-'), events.to_json)
      end
    end
  end
end
