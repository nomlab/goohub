class GoohubCLI < Clian::Cli
    desc "get_event CALENDAR_ID EVENT_ID", "Show event by EVENT_ID"
    #option :output, :default => "redis", :desc => "specify output destination (redis:host:port:name or file)"
  
    def exec(*etag_list)
      settings_file_path = "settings.yml"
      config = YAML.load_file(settings_file_path) if File.exist?(settings_file_path)
      enabled_funnel = config["enabled_funnel"]

      kvs = Goohub::DataStore.create(:file)
      blocks = JSON.parse(kvs.load("blocks.json"))

      blocks.each do |block|
        if enabled_funnel.include?(block['name'])
          code = block['ruby_code']
          eval(code)
          #puts code
        end
      end
    end

no_commands{
    def updated(calendar_id,etag_list)
      raw_resource = client.list_events(calendar_id, single_events: true)
      puts raw_resource.etag
      return !etag_list.include?(raw_resource.etag)
    end

    def get_events(calendar_id)
      min = DateTime.new(Date.today.year.to_i, 1, 1).to_s
      raw_resource = client.list_events(calendar_id, single_events: true)
      return Goohub::Resource::EventCollection.new(raw_resource)
    end

    def insert_event(event,calendar_id)
      google_event = Google::Apis::CalendarV3::Event.new({
        id: event.id,
        summary: event.summary,
        start: event.dump.start,
        end: event.dump.end,
        sequence: event.sequence
      })
      raw_resource = client.list_events(calendar_id, single_events: true)
      event_id_list = raw_resource.items.map{|e| e.id}
      if event_id_list.include?(google_event.id)
        client.update_event(calendar_id, google_event.id, google_event)
        STDERR.puts "Update #{event.summary} to #{calendar_id}"
      else
        client.insert_event(calendar_id, google_event)
        STDERR.puts "Insert #{event.summary} to #{calendar_id}"
      end
    end
  }
  end
  