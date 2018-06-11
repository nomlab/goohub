# coding: utf-8
module Goohub
  class Filter
    def initialize(filter_id, sentence_items)
      @filter_id = filter_id
      @sentence_items = sentence_items
      set_db
      eval("@#{@filter_id} = JSON.parse(@kvs.load(@filter_id))")
    end

    def apply
      return if @filter_id == "no_filter"
      if expand_query("condition") != nil && expand_query("condition") != false
        expand_query("modifier")
      end
      @sentence_items
    end

    private

    #eval では，それまでに定義していない変数名を利用できないため，あえてif文を利用している
    def expand_query(type)
      if type == "condition" then
        method = eval("@#{@filter_id}['condition'].split(':')[0]")
        field =  eval("@#{@filter_id}['condition'].split(':')[1]")
        value =  eval("@#{@filter_id}['condition'].split(':')[2]")
        eval("#{method}(field,value)")
      elsif type == "modifier" then
        method = eval("@#{@filter_id}['modifier'].split(':')[0]")
        field =  eval("@#{@filter_id}['modifier'].split(':')[1]")
        value =  eval("@#{@filter_id}['modifier'].split(':')[2]")
        eval("#{method}(field,value)")
      end
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

    #####################################################
    ### setting_methods
    #####################################################
    def set_db
      summary_delete  ={
        "condition" => "match:summary:.",
        "modifier" => "replace:summary:"
      }
      created_delete  ={
        "condition" => "match:summary:.",
        "modifier" => "replace:created:"
      }
      location_delete  ={
        "condition" => "match:summary:.",
        "modifier" => "replace:location:"
      }

      @kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
      @kvs.store("summary_delete", summary_delete.to_json)
      @kvs.store("created_delete", created_delete.to_json)
      @kvs.store("location_delete", location_delete.to_json)
    end
  end# class Filter
end# module Goohub
