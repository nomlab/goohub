class GoohubCLI < Clian::Cli
  ################################################################
  # Command: events
  ################################################################
  desc "events CALENDAR_ID", "Show events found by CALENDAR_ID"

  def events(calendar_id)
    events =  client.list_events(calendar_id)
    events.items.each do |item|
      puts item.summary.to_s + "(" + item.id.to_s + ")"
    end
  end
end
