require 'redis'
module Goohub
  module DataStore
    class FileStore < Base
      def initialize(options = {})
        settings_file_path = "settings.yml"
        config = YAML.load_file(settings_file_path) if File.exist?(settings_file_path)
        @db_path = config["db_path"]
      end

      def load(key)
        begin
          File.read(@db_path + key)
        rescue
          nil
        end
      end

      def store(key, value)
        begin
          File.write("#{@db_path + key}",value)
        rescue
          nil
        end
      end

      def delete(key)
        begin
          File.delete(@db_path + key)
        rescue
          nil
        end
      end

      def keys
        result = []
        Dir.open(@db_path) do |dir|
          for item in dir
            next if item.match(/^\..*$/)
            result << item
          end
        end
        result
      end

      def glob(pattern, &block)
        raise 'Not implemented'
      end
    end # class FileStore
  end # module DataStore
end # module Goohub
