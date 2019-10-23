# coding: utf-8
module Goohub
  class Filter
    attr_accessor :name, :condition, :filter

    def initialize(name)
      #kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
      kvs = Goohub::DataStore.create(:file)
#      set_db(kvs) # for test data set
      filters = JSON.parse(kvs.load("filters"))
      filters.each { |filter|
        @filter = filter if filter["name"].match(/^#{name}$/)
      }
      @name = @filter['name']
      @condition = @filter['condition']
    end

    private

    #####################################################
    ### test_methods
    #####################################################
    def set_db(kvs)
      summary_delete  ={
        "name" => "summary_delete",
        "condition" => "summary:/.*/",
      }
      created_delete  ={
        "name" => "created_delete",
        "condition" => "summary:/.*/",
      }
      location_delete  ={
        "name" => "location_delete",
        "condition" => "summary:/.*/",
      }
      filters = []
      filters << summary_delete << created_delete << location_delete
      kvs.store("filters", filters.to_json)
    end
  end# class Filter
end# module Goohub
