module Goohub
  module DataStore
    def self.create(type, options = {})
      if type == :redis
        return Goohub::DataStore::RedisStore.new(options)
      else
        raise 'Does Not exists #{type} for DataStore'
      end
    end

    class Base
      # Load the value from data store for the given key
      def load(key)
        raise 'Not implemented'
      end

      # Store the value into data store for the given key
      def store(key, value)
        raise 'Not implemented'
      end

      # Remove the value from data store for the given key
      def delete(key)
        raise 'Not implemented'
      end
    end # class Base

    dir = File.dirname(__FILE__) + "/datastore"

    autoload :RedisStore,        "#{dir}/redis_store.rb"
  end # module DataStore
end # module Goohub
