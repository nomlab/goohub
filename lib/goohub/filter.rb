module Goohub
  class Filter
    def initialize(filter_id, sentence_items)
      @filter_id = filter_id
      @sentence_items = sentence_items
      filter = Struct.new("Filter", :condition, :modifier)
      @summary_delete = filter.new("true","replace:summary:nil")
      @created_delete = filter.new("true","replace:created:nil")
      @location_delete = filter.new("true","replace:location:nil")
    end

    def apply
      return if @filter_id == "no_filter"
      if confirm_condition == true
        modify_event
      end
      @sentence_items
    end

    private

    #####################################################
    ### codition_methods
    #####################################################
    def confirm_condition
      eval(eval("@#{@filter_id}.condition"))
    end

    #####################################################
    ### modify_methods
    #####################################################
    def modify_event
      method = eval("@#{@filter_id}.modifier.split(':')[0]")
      field = eval("@#{@filter_id}.modifier.split(':')[1]")
      value = eval("@#{@filter_id}.modifier.split(':')[2]")
      eval("#{method}(field,#{value})")
    end

    #####################################################
    ### templete_methods
    #####################################################
    def replace(field, str)
      @sentence_items["#{field}"] = str
    end
  end# class Filter
end# module Goohub
