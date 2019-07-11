class GoohubCLI < Clian::Cli
  ################################################################
  # Command: server
  ################################################################
  desc "server CALENDAR_ID START_MONTH ( END_MONTH )", "gets events between START_MONTH ( and END_MONTH ) found by CALENDAR_ID, and output events which not stored DB "
  option :output, :default => "redis", :desc => "specify output destination (redis:host:port:name or file)"
  long_desc <<-LONGDESC
    `goohub server` gets events between START_MONTH ( and END_MONTH ) found by CALENDAR_ID, and output events which not stored DB

    When output is "redis", if other parameter( host or port or name ) is not set,

    host: "localhost", port: "6379", name: "0" is set by default.

  LONGDESC

  def server(calendar_id, start_month, end_month="#{Date.today.year}-#{Date.today.month}")
    start = Goohub::DateFrame::Monthly.new(start_month)
    output, host, port, db_name = options[:output].split(":")

    if !host or host == ""
      host = "localhost"
    end
    if !port or port == ""
      port = "6379"
    end
    if !db_name or db_name == ""
      db_name = "0"
    end

    start.each_to(end_month) do |frame|

      min = frame.to_s
      max = (frame.next_month - Rational(1, 24 * 60 * 60)).to_s # Calculate end of frame for Google Calendar API
      params = [calendar_id, frame.year.to_s, frame.month.to_s]
      raw_resource = client.list_events(params[0], time_max: max, time_min: min, single_events: true)
      events = Goohub::Resource::EventCollection.new(raw_resource)
      kvs = Goohub::DataStore.create(output.intern, {:host => host, :port => port.to_i, :db => db_name.to_i})

      e_ids = []
      if kvs.load("#{calendar_id}-#{start_month}") then
        db_events = JSON.parse(kvs.load("#{calendar_id}-#{start_month}"))
        events.each do |e|
          exist_flag = false
          db_events["items"].each do |db_e|
            if e.summary.to_s == db_e["summary"] then
              exist_flag = true
              break
            end
          end
          e_ids << e.id if exist_flag == false
        end
      else
        events.each do |e|
          e_ids << e.id
        end
      end
      puts e_ids.join(' ')
      kvs.store("#{calendar_id}-#{start_month}", events.to_json) if e_ids[0] != nil
    end
  end# def server
end# class GoohubCLI
