module Goohub
  dir = File.dirname(__FILE__) + "/goohub"

  autoload :Client,               "#{dir}/client.rb"
  autoload :Command,              "#{dir}/command.rb"
  autoload :Config,               "#{dir}/config.rb"
  autoload :VERSION,              "#{dir}/version.rb"
  autoload :Resource,             "#{dir}/resource.rb"
  autoload :DataStore,            "#{dir}/datastore.rb"
  autoload :DateFrame,            "#{dir}/date_frame.rb"
  autoload :Filter,               "#{dir}/filter.rb"
  autoload :Action,               "#{dir}/action.rb"
  autoload :Outlet,               "#{dir}/outlet.rb"
  autoload :Funnel,               "#{dir}/funnel.rb"
  autoload :Parser,               "#{dir}/parser.rb"
  autoload :Expression,           "#{dir}/expression.rb"
end
