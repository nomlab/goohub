# coding: utf-8
require 'json'
require 'uri'
require 'yaml'
require 'mail'
require 'net/https'

class GoohubCLI < Clian::Cli
  desc "share CALENDAR_ID EVENT_ID", "Filtering event by EVENT_ID, and share it by action"
  option :filter, :default => "no_filter", :desc => "specify filter to apply"
  option :action, :default => "stdout", :desc => "specify action to apply"
  long_desc <<-LONGDESC
FILTER is `no_filter`, `summary_delete`, `created_delete`, or `location_delete`

ACTION is `stdout`, `calendar:POST_CALENDAR_ID`, `mail:POST_MAIL_ADDRESS`, or `slack`

If you use `slack` in ACTION, you need get incoming-webhook url and set it in settings.yml

If you use `mail` in ACTION, you need get mail_address and password and set these in settings.yml
LONGDESC

  def share(calendar_id, event_id)
    event = client.get_event(calendar_id, event_id)
    sentence_items = parse_event(event)
    filter = Filter.new(options[:filter], sentence_items)
    sentence_items = filter.apply
    action = Action.new(options[:action], sentence_items)
    action.apply
  end

  private

  def parse_event(event)
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
end# class GoohubCLI

class Filter
  def initialize(name, sentence_items)
    @name = name
    @sentence_items = sentence_items
  end

  def apply
    return if @name == "no_filter"
    @sentence_items["location"] = nil if @name== "location_delete"
    @sentence_items["created"] = nil if @name == "created_delete"
    @sentence_items["summary"] = nil if @name == "summary_delete"
    @sentence_items
  end
end# class Filter

class Action
  def initialize(name, sentence_items)
    @name = name
    @sentence_items = sentence_items
  end

  def apply
    puts make_sentence if @name == "stdout"
    post_slack if @name == "slack"
    post_calendar(@name.partition(":")[2]) if @name.partition(":")[0] == "calendar"
    post_mail(@name.partition(":")[2]) if @name.partition(":")[0] == "mail"
  end

  private

  def make_sentence
    sentence = ""
    @sentence_items.each{ |key, value|
      sentence <<  "#{key}: #{value}\n"
    }
    sentence
  end

  def post_slack(options = {})
    sentence = make_sentence
    set_settings
    payload = options.merge({text: sentence})
    incoming_webhook_url = ENV['INCOMING_WEBHOOK_URL'] || @config["slack_incoming_webhook_url"]
    uri = URI.parse(incoming_webhook_url)
    res = nil
    json = payload.to_json
    request = "payload=" + json

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = http.post(uri.request_uri, request)
    end
    puts "Slack post is end, post content is under"
    puts  sentence
    return res
  end

  def set_settings
    settings_file_path = "settings.yml"
    @config = YAML.load_file(settings_file_path) if File.exist?(settings_file_path)
  end

  def post_calendar(calendar_id)
    event =
      Google::Apis::CalendarV3::Event.new({
                                            summary: @sentence_items["summary"],
                                            start: {
                                              date_time: @sentence_items["start_time"],
                                            },
                                            end: {
                                              date_time: @sentence_items["end_time"],
                                            },
                                            location: @sentence_items["location"]
                                          })
    result = client.insert_event(calendar_id, event)
    puts "Event created: #{result.html_link}"
  end

  def post_mail(post_address)
    sentence = make_sentence
    set_settings
    address = @config['mail_address']
    password = @config['mail_password']
    mail = Mail.new do
      from     "#{address}"
      to       "#{post_address}"
      subject  "Goohub share event"
      body     "#{sentence}"
    end

    options = { :address               => "smtp.#{address.split('@')[1]}",
                :port                  => 587,
                :domain                => "#{address.split('@')[1]}",
                :user_name             => "#{address.split('id')[0]}",
                :password              => "#{password}",
                :authentication        => :plain,
                :enable_starttls_auto  => true  }

    mail.charset = 'utf-8'
    mail.delivery_method(:smtp, options)
    mail.deliver
    puts "Mail send is end, post content is under"
    puts  sentence
  end
end# class Action
