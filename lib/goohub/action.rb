# coding: utf-8
module Goohub
  class Action
    def initialize(action_id, sentence_items, client)
      @type = action_id.partition(":")[0]
      @sentence_items = sentence_items
      @client = client
      @export_address = action_id.partition(":")[2]
      @kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
      set_db
      actions = load("actions")
      actions.each { |a|
        @action = a if a["name"]["#{@type}"]
      }
    end

    def apply
      converter = @action['converter']
      informant = @action['informant']
      eval("#{informant}(#{converter})")
    end

    private

    #####################################################
    ### process_methods
    #####################################################
    def convert_sentence
      sentence = ""
      @sentence_items.each{ |key, value|
        sentence <<  "#{key}: #{value}\n"
      }
      sentence
    end

    def convert_google_event
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
      event
    end

    #####################################################
    ### export_methods
    #####################################################
    def inform_stdout(sentence)
      puts sentence
    end

    def inform_slack(sentence, options = {})
      payload = options.merge({text: sentence})
      set_settings
      incoming_webhook_url = ENV['INCOMING_WEBHOOK_URL'] || @config["slack_incoming_webhook_url"]
      uri = URI.parse(incoming_webhook_url)
      res = nil
      json = payload.to_json
      request = "payload=" + json
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        res = http.post(uri.request_uri, request)
      end
      return res
    end

    def inform_calendar(event)
      result = @client.insert_event(@export_address, event)
    end

    def inform_mail(sentence)
      set_settings
      # なぜか，インスタンス変数を直接mailのtoにつっこむと落ちるため，一度変数にうつす
      to = @export_address
      address = @config['mail_address']
      password = @config['mail_password']
      mail = Mail.new do
        from     "#{address}"
        to       "#{to}"
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
    end

    #####################################################
    ### setting_methods
    #####################################################
    def set_settings
      settings_file_path = "settings.yml"
      @config = YAML.load_file(settings_file_path) if File.exist?(settings_file_path)
    end

    def set_db
      stdout  ={
        "id" => "1",
        "name" => "stdout",
        "converter" => "convert_sentence",
        "informant" => "inform_stdout"
      }
      slack  ={
        "id" => "2",
        "name" => "slack",
        "converter" => "convert_sentence",
        "informant" => "inform_slack"
      }
      calendar  ={
        "id" => "3",
        "name" => "calendar",
        "converter" => "convert_google_event",
        "informant" => "inform_calendar"
      }
      mail  ={
        "id" => "4",
        "name" => "mail",
        "converter" => "convert_sentence",
        "informant" => "inform_mail"
      }

      actions = []
      actions << stdout << slack << calendar << mail
      register(actions, "actions")
    end

    #####################################################
    ### db_methods
    #####################################################

    def register(h, key)
      @kvs.store(key, h.to_json)
    end

    def delete(key)
      @kvs.delete(key)
    end

    def load(key)
      JSON.parse(@kvs.load(key))
    end
  end# class Action
end# module Goohub
