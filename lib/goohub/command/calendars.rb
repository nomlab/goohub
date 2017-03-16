class GoohubCLI < Clian::Cli
  desc "calendars", "List calendars"

  def calendars
    calendars = client.list_calendar_lists()
    calendars.items.each do |c|
      calendar = Goohub::Resource::Calendar.new(c)
      puts "#{calendar.summary} (#{calendar.id})"
    end
  end
end
