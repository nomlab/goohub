class GoohubCLI < Clian::Cli
  ################################################################
  # Command: events
  ################################################################
  desc "events CALENDAR_ID START", "get and store events between START(year-month) found by CALENDAR_ID"
  option :end, :desc => "specify end month of range (year-month)"
  option :output, :default => "stdout", :desc => "specify output destination (stdout or redis:host[Default:localhost]:port[Default:6379]:name[Default:0])"

  def events(calendar_id, start_date)
    start = Goohub::DateFrame::Monthly.new(start_date)
    if options[:end]
      end_date = options[:end]
    else
      now = Date.today
      end_date = "#{now.year}-#{now.month}"
    end

    output, host, port, db_name = options[:output].split(":")
    if output and (output != "stdout" or output != "")
      if !host or host == ""
        host = "localhost"
      end
      if !port or port == ""
        port = "6379"
      end
      if !db_name or db_name == ""
        db_name = "0"
      end

      puts "output: #{output}"
      puts "host: #{host}"
      puts "port: #{port}"
      puts "db_name: #{db_name}"
    else
      output = "stdout"

      puts "output: #{output}"
    end
    puts "----------------------------"
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
