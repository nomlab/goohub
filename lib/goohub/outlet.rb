# coding: utf-8
module Goohub
  class Outlet
    attr_accessor :name, :informant, :outlet

    def initialize(name)
      kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
      set_db(kvs) # for test data set
      outlets = JSON.parse(kvs.load("outlets"))
      outlets.each { |outlet|
        @outlet = outlet if outlet["name"]["#{name}"]
      }
      @name = @outlet['name']
      @informant = @outlet['informant']
    end

    private

    #####################################################
    ### test_methods
    #####################################################
    def set_db(kvs) # for test data set
      stdout  ={
        "name" => "stdout",
        "informant" => "stdout"
      }
      slack  ={
        "name" => "slack",
        "informant" => "slack"
      }
      calendar  ={
        "name" => "google_calendar",
        "informant" => "google_calendar:kjtbw1219@gmail.com"
      }
      mail  ={
        "name" => "mail",
        "informant" => "mail:kjtbw1219lab@gmail.com"
      }

      outlets = []
      outlets << stdout << slack << calendar << mail
      kvs.store("outlets", outlets.to_json)
    end

  end# class Outlet
end# module Goohub
