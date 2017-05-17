require 'redis'
module Goohub
  module DataStore
    class RedisStore < Base
      def initialize(options = {})
        @redis = Redis.new(options)
      end

      def load(key)
        @redis.get(key)
      end

      def store(key, value)
        @redis.set(key, value)
      end

      def delete(key)
        @redis.del(key)
      end
    end # class RedisStore
  end # module DataStore
end # module Goohub
