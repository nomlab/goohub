class GoohubCLI < Clian::Cli
  ################################################################
  # Command: events
  ################################################################
  desc "events CALENDAR_ID START_MONTH ( END_MONTH )", "gets and stores events between START_MONTH ( and END_MONTH ) found by CALENDAR_ID"
  option :output, :default => "stdout", :desc => "specify output destination ( stdout or redis:host:port:name )"
  long_desc <<-LONGDESC
    `goohub events` gets and stores events between START_MONTH ( and END_MONTH ) found by CALENDAR_ID

    When output is "redis", if other parameter( host or port or name ) is not set,

    host: "localhost", port: "6379", name: "0" is set by default.
  LONGDESC

  #def events(calendar_id, start_month, end_month="#{Date.today.year}-#{Date.today.month}")
  def events(calendar_id, start_month, end_month="#{Date.today.year}-12")
    start_year_month = start_month.split('-')
    start_year_month[1] = '01' if start_year_month[1] == nil
    end_year_month = end_month.split('-')
    end_year_month[1] = '12' if end_year_month[1] == nil
    #start = Goohub::DateFrame::Monthly.new(start_month)
    output, host, port, db_name = options[:output].split(":")

    puts "output: #{output}"
    if output != "stdout"
      if !host or host == ""
        host = "localhost"
      end
      if !port or port == ""
        port = "6379"
      end
      if !db_name or db_name == ""
        db_name = "0"
      end

      puts "host: #{host}"
      puts "port: #{port}"
      puts "db_name: #{db_name}"
    end
    puts "----------------------------"

    #endm = Goohub::DateFrame::Monthly.new(end_month)
    min = DateTime.new(start_year_month[0].to_i, start_year_month[1].to_i, 1).to_s
    max = (DateTime.new(end_year_month[0].to_i, end_year_month[1].to_i, 1).next_month - Rational(1, 24 * 60 * 60)).to_s
    params = [calendar_id, start_year_month[0].to_s, 0.to_s]
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
      puts kvs.store(params.join('-') + '.json', events.to_json)
    end
    
=begin
    start.each_to(end_month) do |frame|

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
=end
  end
end
