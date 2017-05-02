module Goohub
  dir = File.dirname(__FILE__) + "/goohub"

  autoload :Client,               "#{dir}/client.rb"
  autoload :Command,              "#{dir}/command.rb"
  autoload :Config,               "#{dir}/config.rb"
  autoload :VERSION,              "#{dir}/version.rb"
  autoload :Resource,             "#{dir}/resource.rb"
  autoload :DataStore,            "#{dir}/datastore.rb"
end
