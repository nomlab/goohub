class GoohubCLI < Clian::Cli
  ################################################################
  # Command: events
  ################################################################
  desc "events CALENDAR_ID START", "get and store events between START(year-month) found by CALENDAR_ID"
  option :end, :desc => "specify end month of range (year-month)"
  option :output, :default => "stdout", :desc => "specify output destination (stdout or redis:host:port:name)"

  def events(calendar_id, start_date)
    start = Goohub::DateFrame::Monthly.new(start_date)
    if options[:end]
      end_date = options[:end]
    else
      now = Date.today
      end_date = "#{now.year}-#{now.month}"
    end

    output, host, port, db_name = options[:output].split(":")
    if output != "stdout" and (!host or !port or !db_name)
      puts 'ERROR: "goohub events" was called with missing arguments for outputs'
      puts 'USAGE: If you want to store events to some kvs, you should set "kvs_name:hostname:port:db_name" to output'
      exit
    end

    start.each_to(end_date) do |frame|

      min = frame.to_s
      max = (frame.next_month - Rational(1, 24 * 60 * 60)).to_s # Calculate end of frame for Google Calendar API
      params = [calendar_id, frame.year.to_s, frame.month.to_s]
      puts "Get events of "+ params[1] + "-" + params[2]
      raw_resource = client.list_events(params[0], time_max: max, time_min: min, single_events: true)
      events = Goohub::Resource::EventCollection.new(raw_resource)

      if output == "stdout"
        events.each do |item|
          puts item.summary.to_s + "(" + item.id.to_s + ")"
        end
      else
        puts "Store events to " + output
        print "Status: "
        kvs = Goohub::DataStore.create(output.intern, {:host => host, :port => port.to_i, :db => db_name.to_i})
        puts kvs.store(params.join('-'), events.to_json)
      end
    end
  end
end
