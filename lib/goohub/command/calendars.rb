class GoohubCLI < Clian::Cli
  desc "calendars", "List calendars"

  def calendars
    raw_resource = client.list_calendar_lists()
    calendars = Goohub::Resource::CalendarCollection.new(raw_resource)
    calendars.each do |c|
      puts "#{c.summary} (#{c.id})"
    end
  end
end
