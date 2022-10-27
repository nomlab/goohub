class GoohubCLI < Clian::Cli
  ################################################################
  # Command: post_calendar
  ################################################################
  desc "post_calendar CALENDAR_NAME", "Create an calendar"

  def post_calendar(calendar_name)
    puts calendar_name
    calendar = Google::Apis::CalendarV3::Calendar.new(
        summary: calendar_name,
        time_zone: 'Asia/Tokyo'
    )
    result = client.insert_calendar(calendar)
    puts "Calendar created: #{result.id}"
  end
end
