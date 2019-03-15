class GoohubCLI < Clian::Cli
  ################################################################
  # Command: post_event
  ################################################################
  desc "post_event CALENDAR_ID TITLE START END", "Create an event to CALENDAR_ID"

  def post_event(calendar_id, title, start_time, end_time)
    if start_time.class == Icalendar::Values::Date then
      event = Google::Apis::CalendarV3::Event.new({
                                                    summary: title,
                                                    start: {
                                                      date: start_time,
                                                    },
                                                    end: {
                                                      date: end_time,
                                                    }
                                                  })

    elsif start_time.class == Icalendar::Values::DateTime then
      event = Google::Apis::CalendarV3::Event.new({
                                                    summary: title,
                                                    start: {
                                                      date_time: start_time,
                                                    },
                                                    end: {
                                                      date_time: end_time,
                                                    }
                                                  })
    else
      puts "Event is not created,  because event format is wrong."
      return
    end
    result = client.insert_event(calendar_id, event)
    puts "Event created: #{result.html_link}"
  end
end
