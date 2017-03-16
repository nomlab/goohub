class GoohubCLI < Clian::Cli
  desc "calendars", "List calendars"

  def calendars
    calendars = client.list_calendar_lists()
    calendars.items.each do |c|
      puts "#{c.summary}(#{c.id})"
    end
  end
end
