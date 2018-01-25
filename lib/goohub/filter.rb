module Goohub
  class Filter
    def initialize(name, sentence_items)
      @name = name
      @sentence_items = sentence_items
    end

    def apply
      return if @name == "no_filter"
      @sentence_items["location"] = nil if @name== "location_delete"
      @sentence_items["created"] = nil if @name == "created_delete"
      @sentence_items["summary"] = nil if @name == "summary_delete"
      @sentence_items
    end
  end# class Filter
end# module Goohub
