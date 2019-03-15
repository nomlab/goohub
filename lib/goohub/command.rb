dir = File.dirname(__FILE__) + "/command"

# Example: if you would add profile command,
# create profile.rb in command/
# and add `require` here like:
#    require "#{dir}/profile.rb"

require "#{dir}/init.rb"
require "#{dir}/auth.rb"
require "#{dir}/calendars.rb"
require "#{dir}/get_event.rb"
require "#{dir}/events.rb"
require "#{dir}/post_event.rb"
require "#{dir}/post_ics.rb"
