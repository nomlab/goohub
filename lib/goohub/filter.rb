# coding: utf-8
module Goohub
  class Filter
    def initialize(filter_id, sentence_items)
      @filter_id = filter_id
      @sentence_items = sentence_items
      filter = Struct.new("FilterID", :condition, :modifier)
      @summary_delete  = filter.new("match:summary:.","replace:summary:")
      @created_delete  = filter.new("match:summary:.","replace:created:")
      @location_delete = filter.new("match:summary:.","replace:location:")
    end

    def apply
      return if @filter_id == "no_filter"
      if expand_query("condition") != nil && expand_query("condition") != false
        expand_query("modifier")
      end
      @sentence_items
    end

    private

    def expand_query(type)
      method = eval("@#{@filter_id}.#{type}.split(':')[0]")
      field = eval("@#{@filter_id}.#{type}.split(':')[1]")
      value = eval("@#{@filter_id}.#{type}.split(':')[2]")
      eval("#{method}(field,value)")
    end

    #####################################################
    ### templete_methods
    #####################################################
    def replace(field, str)
      @sentence_items["#{field}"] = str
    end

    def match(field, pattern)
      @sentence_items["#{field}"].match(pattern)
    end

    def include?(field, str)
      @sentence_items["#{field}"].include?(str)
    end
  end# class Filter
end# module Goohub
