# coding: utf-8
module Goohub
  class Outlet
    attr_accessor :id, :name, :informant, :outlet

    def initialize(name)
      kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
      #      set_db(kvs) # for test data set
      outlets = JSON.parse(kvs.load("outlets"))
      outlets.each { |outlet|
        @outlet = outlet if outlet["name"]["#{name}"]
      }
      @id = @outlet['id']
      @name = @outlet['name']
      @informant = @outlet['informant']
    end

    private

    #####################################################
    ### test_methods
    #####################################################
    def set_db # for test data set
      stdout  ={
        "id" => "1",
        "name" => "stdout",
        "informant" => "inform_stdout"
      }
      slack  ={
        "id" => "2",
        "name" => "slack",
        "informant" => "inform_slack"
      }
      calendar  ={
        "id" => "3",
        "name" => "calendar",
        "informant" => "inform_calendar"
      }
      mail  ={
        "id" => "4",
        "name" => "mail",
        "informant" => "inform_mail"
      }

      outlets = []
      outlets << stdout << slack << calendar << mail
      @kvs.store("outlets", outlets.to_json)
    end

  end# class Outlet
end# module Goohub
