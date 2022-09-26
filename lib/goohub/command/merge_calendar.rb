class GoohubCLI < Clian::Cli
  ################################################################
  # Command: merge_calendar
  ################################################################
  desc "merge_calendar CALENDAR_ID", "Merge calendar"

  def merge_calendar
    settings_file_path = "settings.yml"
    config = YAML.load_file(settings_file_path) if File.exist?(settings_file_path)
    merge_calendar_id = config["merge_calendar_id"]
    source_calendar_id_list = config["source_calendar_id"]

    min = DateTime.new(Date.today.year, 1, 1).to_s
    raw_resource = client.list_events(merge_calendar_id,time_min: min)
    events = Goohub::Resource::EventCollection.new(raw_resource)
    event_id_list = []
    event_sequence_list = {}
    events.each do |e|
      event_id_list << e.id
      event_sequence_list[e.id] = e.sequence
    end
    
    source_calendar_id_list.each do |id|
      raw_resource = client.list_events(id,time_min: min)
      #events = Goohub::Resource::EventCollection.new(raw_resource)
      raw_resource.items.each do |event|
          #event = client.get_event(id, item.id)
          if event_id_list.include?(event.id)
            #mcal_event = client.get_event(merge_calendar_id, event.id)
            #event.sequence = mcal_event.sequence
            event.sequence = event_sequence_list[event.id]
            client.update_event(merge_calendar_id, event.id, event)
          else
            client.insert_event(merge_calendar_id, event)
          end
      end
    end
  end
end
