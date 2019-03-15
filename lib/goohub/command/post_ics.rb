require 'icalendar'

class GoohubCLI < Clian::Cli
  ################################################################
  # Command: post_ics
  ################################################################
  desc "post_ics CALENDAR_ID ICS_FILE", "Create ics file events to CALENDAR_ID"

  def post_ics(calendar_id, ics_file)
    ics_file = File.open(ics_file)
    events = Icalendar::Event.parse(ics_file)
    count = 0

    puts "Start #{events.size} events post."
    events.each { |e|
      begin
        count = count + 1
        post_event(calendar_id, e.summary, e.dtstart, e.dtend)
      rescue => error
        puts "#########################"
        puts "#{error}"
        puts "#{e.summary}, #{e.dtstart}, #{e.dtend}"
        puts "#########################"
      end
    }
    puts "Done #{count}/#{events.size} events post."
  end
end
