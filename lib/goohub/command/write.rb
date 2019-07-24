# coding: utf-8

class GoohubCLI < Clian::Cli
  desc "write TYPE NAME QUERY", "Write NAME and QUERY into DB by TYPE"
  option :action_name , :default => nil, :desc =>"action_name for funnel"
  option :outlet_name , :default => nil, :desc =>"outlet_name for funnel"
  long_desc <<-LONGDESC
TYPE is filters, actions, outlets, and funnels

NAME is colum name

ARG is colum query

If you set `funnel` in TYPE, you must set action_name option and outlet_name option
LONGDESC

  def write(type, name ,query)
    kvs = Goohub::DataStore.create(:file)
    case type
    when "filters" then
      puts "Save this filter\nname:#{name}, condition:#{query}\n"
      filters = []
      filters = JSON.parse(kvs.load("filters")) if kvs.load("filters")
      filter = {
        "name" => "#{name}",
        "condition" => "#{query}"
      }
      filters.each_with_index{ |v, i|
        if v["name"] == filter["name"]
          filters.delete_at(i);
        end
      }
      filters << filter
      print "Status: "
      puts kvs.store("filters", filters.to_json)

    when "actions" then
      puts "Save this action\nname:#{name}, modifier:#{query}\n"
      actions = []
      actions = JSON.parse(kvs.load("actions")) if kvs.load("actions")
      action = {
        "name" => "#{name}",
        "modifier" => "#{query}"
      }
      actions.each_with_index{ |v, i|
        if v["name"] == action["name"]
          actions.delete_at(i);
        end
      }
      actions << action
      print "Status: "
      puts kvs.store("actions", actions.to_json)

    when "outlets" then
      puts "Save this outlet\nname:#{name}, informant:#{query}\n"
      outlets = []
      outlets = JSON.parse(kvs.load("outlets")) if kvs.load("outlets")
      outlet = {
        "name" => "#{name}",
        "informant" => "#{query}"
      }
      outlets.each_with_index{ |v, i|
        if v["name"] == outlet["name"]
          outlets.delete_at(i);
        end
      }
      outlets << outlet
      print "Status: "
      puts kvs.store("outlets", outlets.to_json)

    when "funnels" then
      if options[:action_name] == nil or options[:outlet_name] == nil then
        puts "If you set `funnel` in TYPE, you must set action_name option and outlet_name option!"
        return
      end
      puts "Save this funnel\nname:#{name}, filter_name:#{query}, action_name:#{options[:action_name]}, outlet_name:#{options[:outlet_name]}\n"
      funnels = []
      funnels = JSON.parse(kvs.load("funnels")) if kvs.load("funnels")
      funnel = {
        "name" => "#{name}",
        "filter_name" => "#{query}",
        "action_name" => "#{options[:action_name]}",
        "outlet_name" => "#{options[:outlet_name]}"
      }
      funnels.each_with_index{ |v, i|
        if v["name"] == funnel["name"]
          funnels.delete_at(i);
        end
      }
      funnels << funnel
      print "Status: "
      puts kvs.store("funnels", funnels.to_json)
    else
      puts "else"
    end
  end# def read
end# class GoohubCLI
