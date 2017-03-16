module Goohub
  dir = File.dirname(__FILE__) + "/goohub"

  autoload :Command,              "#{dir}/command.rb"
  autoload :Config,               "#{dir}/config.rb"
  autoload :VERSION,              "#{dir}/version.rb"
  autoload :Resource,             "#{dir}/resource.rb"
end
