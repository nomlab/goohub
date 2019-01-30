# coding: utf-8
module Goohub
  class Filter
    attr_accessor :id, :name, :condition, :filter

    def initialize(name)
      kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
      set_db(kvs) # for test data set
      filters = JSON.parse(kvs.load("filters"))
      filters.each { |filter|
        @filter = filter if filter["name"]["#{name}"]
      }
      @id = @filter['id']
      @name = @filter['name']
      @condition = @filter['condition']
    end

    private

    #####################################################
    ### test_methods
    #####################################################
    def set_db(kvs)
      summary_delete  ={
        "id" => "1",
        "name" => "summary_delete",
        "condition" => "summary:/.*/",
      }
      created_delete  ={
        "id" => "2",
        "name" => "created_delete",
        "condition" => "summary:/.*/",
      }
      location_delete  ={
        "id" => "3",
        "name" => "location_delete",
        "condition" => "summary:/.*/",
      }
      filters = []
      filters << summary_delete << created_delete << location_delete
      kvs.store("filters", filters.to_json)
    end
  end# class Filter
end# module Goohub
