# coding: utf-8
module Goohub
  class Funnel
    attr_accessor :name, :filter_name, :action_name, :outlet_name

    def initialize(name)
      kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
      #set_db(kvs) # for test data set
      funnels = JSON.parse(kvs.load("funnels"))
      funnels.each { |funnel|
        @funnel = funnel if funnel["name"]["#{name}"]
      }
      @name = @funnel['name']
      @filter_name = @funnel['filter_name']
      @action_name = @funnel['action_name']
      @outlet_name = @funnel['outlet_name']
    end

    private

    #####################################################
    ### test_methods
    #####################################################
    def set_db(kvs)
      summary_delete  ={
        "name" => "summary_delete",
        "filter_name" => "summary_delete",
        "action_name" => "stdout",
        "outlet_name" => "stdout"
      }
      funnels = []
      funnels << summary_delete
      kvs.store("funnels", funnels.to_json)
    end
  end# class Funnel
end# module Goohub
