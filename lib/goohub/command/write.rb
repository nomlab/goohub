# coding: utf-8

class GoohubCLI < Clian::Cli
  desc "write TYPE NAME QUERY", "Write NAME and QUERY into DB by TYPE"
  long_desc <<-LONGDESC
TYPE is filters, actions, outlets, and funnels

NAME is colum name

ARG is colum query
LONGDESC

  def write(type, name ,query)
    kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
    case type
    when "filters" then
      puts "Save this filter\nname:#{name}, condition:#{query}\n"
      filters = JSON.parse(kvs.load("filters"))
      filter = {
        "name" => "#{name}",
        "condition" => "#{query}"
      }
      filters << filter
      filters.uniq!
      print "Status: "
      puts kvs.store("filters", filters.to_json)

    when "actions" then
      puts "Save this action\nname:#{name}, modifier:#{query}\n"
      actions = JSON.parse(kvs.load("actions"))
      action = {
        "name" => "#{name}",
        "modifier" => "#{query}"
      }
      actions << action
      actions.uniq!
      print "Status: "
      puts kvs.store("actions", actions.to_json)

    when "outlets" then
      puts "Save this outlet\nname:#{name}, informant:#{query}\n"
      outlets = JSON.parse(kvs.load("outlets"))
      outlet = {
        "name" => "#{name}",
        "informant" => "#{query}"
      }
      outlets << outlet
      outlets.uniq!
      print "Status: "
      puts kvs.store("outlets", outlets.to_json)
    else
      puts "else"
    end
  end# def read
end# class GoohubCLI
