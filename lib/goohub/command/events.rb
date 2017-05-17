class GoohubCLI < Clian::Cli
  ################################################################
  # Command: events
  ################################################################
  desc "events CALENDAR_ID START END", "get and store events between START(year-month) and END(year-month) found by CALENDAR_ID"
  option :kvs

  def events(calendar_id, start_m, end_m)
    s = start_m.split('-')
    e = end_m.split('-')

    (DateTime.new(s[0].to_i,s[1].to_i)..DateTime.new(e[0].to_i,e[1].to_i))
      .select {|d| d.day == 1}
      .each do |d|

      min = d.to_s
      max = (d.next_month - Rational(1, 24 * 60 * 60)).to_s
      params = [calendar_id, d.year.to_s, d.month.to_s]
      puts "Get events of "+ params[1] + "-" + params[2]
      raw_resource = client.list_events(params[0], time_max: max, time_min: min, single_events: true)
      events = Goohub::Resource::EventCollection.new(raw_resource)

      if options[:kvs].nil?
        events.each do |item|
          puts item.summary.to_s + "(" + item.id.to_s + ")"
        end
      else
        puts "Store events to " + options[:kvs]
        print "Status: "
        kvs = Goohub::DataStore.create(options[:kvs].intern)
        puts kvs.store(params.join('-'), events.to_json)
      end
    end
  end
end
