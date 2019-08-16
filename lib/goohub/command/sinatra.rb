# coding: utf-8
require 'sinatra/base'
require "sinatra/json"
require 'sinatra/cross_origin'
require "json"

class GoohubCLI < Clian::Cli
  desc "sinatra", "Work sinatra server in localhost:4567"

  def sinatra
    controller = Sinatra.new do
      enable :logging

      configure do
        set (:info) {
          settings_file_path = "settings.yml"
          YAML.load_file(settings_file_path) if File.exist?(settings_file_path)
        }
        enable :cross_origin
      end

      before do
        response.headers['Access-Control-Allow-Origin'] = '*'
      end

      options "*" do
        response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
        response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
        response.headers["Access-Control-Allow-Origin"] = "*"
        200
      end

      ################################################################
      # GET
      ################################################################
      get '/' do
        "Hello! This is goohub server"
      end

      get '/info/:key?' do
        return json settings.info if !params["key"]
        json settings.info[params["key"]]
      end

      get '/funnels/:name?' do
        kvs = Goohub::DataStore.create(:file)
        funnels = JSON.parse(kvs.load("funnels"))
        return json funnels if !params["name"]
        funnels.each { |f|
          return json  f if f["name"][params["name"]]
        }
      end

      get '/filters/:name?' do
        kvs = Goohub::DataStore.create(:file)
        filters = JSON.parse(kvs.load("filters"))
        return json filters if !params["name"]
        filters.each { |f|
          return json  f if f["name"][params["name"]]
        }
      end

      get '/actions/:name?' do
        kvs = Goohub::DataStore.create(:file)
        actions = JSON.parse(kvs.load("actions"))
        return json actions if !params["name"]
        actions.each { |a|
          return json  a if a["name"][params["name"]]
        }
      end

      get '/outlets/:name?' do
        kvs = Goohub::DataStore.create(:file)
        outlets = JSON.parse(kvs.load("outlets"))
        return json outlets if !params["name"]
        outlets.each { |o|
          return json  o if o["name"][params["name"]]
        }
      end

      get '/calendars/:id?' do
        kvs = Goohub::DataStore.create(:file)
        cal_names = []
        kvs.keys.each { |k|
          if k.match(/.*@.*/)
            name = k.partition("@")[0]
            period = k.partition("@")[2].partition("-")[2]
            cal_names.push({name => [period]}) if cal_names == []
            cal_names.each { |cal|
              if cal[name]
                cal[name].push(period)
                cal[name].uniq!
              else
                cal_names.push({name => [period]})
              end
            }
          end
        }

        return json cal_names if !params["id"]
        !params["period"]
        cal_names.each { |c|
          return json c if c[params["id"]]
        }
      end

      get '/calendars/:id/:period' do
        kvs = Goohub::DataStore.create(:file)
        kvs.keys.each { |k|
          if k.match(/#{params['id']}.*#{params['period']}/)
            return json JSON.parse(kvs.load(k))
          end
        }
      end

      ################################################################
      # POST
      ################################################################
      post '/funnels' do
        data = JSON.parse(request.body.read)
        kvs = Goohub::DataStore.create(:file)

        filters = []
        filters = JSON.parse(kvs.load("filters")) if kvs.load("filters")
        filter = {
          "name" => "#{data['filter']['name']}",
          "condition" => "#{data['filter']['condition']}"
        }
        filters.each_with_index{ |v, i|
          if v["name"] == filter["name"]
            filters.delete_at(i);
          end
        }
        filters << filter
        kvs.store("filters", filters.to_json)

        kvs = Goohub::DataStore.create(:file)
        actions = []
        actions = JSON.parse(kvs.load("actions")) if kvs.load("actions")
        action = {
          "name" => "#{data['action']['name']}",
          "modifier" => "#{data['action']['modifier']}"
        }
        actions.each_with_index{ |v, i|
          if v["name"] == action["name"]
            actions.delete_at(i);
          end
        }
        actions << action
        kvs.store("actions", actions.to_json)

        kvs = Goohub::DataStore.create(:file)
        outlets = []
        outlets = JSON.parse(kvs.load("outlets")) if kvs.load("outlets")
        outlet = {
          "name" => "#{data['outlet']['name']}",
          "informant" => "#{data['outlet']['informant']}"
        }
        outlets.each_with_index{ |v, i|
          if v["name"] == outlet["name"]
            outlets.delete_at(i);
          end
        }
        outlets << outlet
        kvs.store("outlets", outlets.to_json)

        kvs = Goohub::DataStore.create(:file)
        funnels = []
        funnels = JSON.parse(kvs.load("funnels")) if kvs.load("funnels")
        funnel = {
          "name" => "#{data['name']}",
          "filter_name" => "#{data['filter']['name']}",
          "action_name" => "#{data['action']['name']}",
          "outlet_name" => "#{data['outlet']['name']}"
        }
        funnels.each_with_index{ |v, i|
          if v["name"] == funnel["name"]
            funnels.delete_at(i);
          end
        }
        funnels << funnel
        kvs.store("funnels", funnels.to_json)
      end# post /funnels
    end # Sinatra.new

    controller.run!

  end# method sinatra
end# class GoohubCLI
