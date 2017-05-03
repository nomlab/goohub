require 'redis'
class GoohubCLI < Clian::Cli
  ################################################################
  # Command: events_to_redis
  ################################################################
  desc "events_to_redis CALENDAR_ID YEAR MONTH", "save events to redis server by CALENDAR_ID-YEAR-MONTH"

  def events_to_redis(calendar_id, year, month)

    params = [calendar_id, year, month]

    min = DateTime.new(params[1].to_i,params[2].to_i,1).to_s
    max = DateTime.new(params[1].to_i,params[2].to_i,-1,-1,-1,-1).to_s
    raw_resource = client.list_events(calendar_id, time_max: max, time_min: min, single_events: true)
    events = Goohub::Resource::EventCollection.new(raw_resource)

    redis = Goohub::DataStore::RedisStore.new
    puts redis.store(params.join("-"), events.to_json)
  end
end
