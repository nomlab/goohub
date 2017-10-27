class GoohubCLI < Clian::Cli
  desc "share CALENDAR_ID EVENT_ID", "Share event by EVENT_ID"

  def share(calendar_id, event_id, filter = "location_delete", action = "stdout")
    event = client.get_event(calendar_id, event_id)
    sentence_items = make_default_sentence_items(event)
    sentence_items = apply_filter(sentence_items, filter)
    sentence = make_sentence(sentence_items)
    apply_action(sentence, action)
  end

  private

  def make_default_sentence_items(event)
    sentence_items = {}
    sentence_items["summary"] =    event.summary
    sentence_items["id"] =         event.id
    sentence_items["created"] =    event.created
    sentence_items["kind"] =       event.kind
    sentence_items["organized"] =  event.organizer.display_name
    sentence_items["start_time"] = event.start.date_time
    sentence_items["end_time"] =   event.end.date_time
    sentence_items["location"] =   event.location
    sentence_items
  end

  def apply_filter(sentence_items, filter)
    sentence_items["location"] = nil if filter == "location_delete"
    sentence_items["created"] = nil if filter == "created_delete"
    sentence_items["summary"] = nil if filter == "summary_delete"
    sentence_items
  end

  def make_sentence(sentence_items)
    sentence = ""
    sentence_items.each{ |key, value|
      item_name = "#{key}:"
      # This while is need to align indent
      while item_name.length < 17
        item_name << " "
      end

      sentence <<  item_name + "#{value}" + "\n"
    }
    sentence
  end

  def apply_action(sentence, action)
    puts sentence if action == "stdout"
  end
end# class GoohubCLI
