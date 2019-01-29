# coding: utf-8
module Goohub
  class Action
    attr_accessor :id, :name, :modifier, :action

    def initialize(name)
      kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
      #      set_db(kvs) # for test data set
      actions = JSON.parse(kvs.load("actions"))
      actions.each { |action|
        @action = action if action["name"]["#{name}"]
      }
      @id = @action['id']
      @name = @action['name']
      @informant = @action['modifier']
    end

    private

    #####################################################
    ### setting_methods
    #####################################################
    def set_db(kvs)
      stdout  ={
        "id" => "1",
        "name" => "stdout",
        "modifier" => "replace:summary:hoge"
      }
      slack  ={
        "id" => "2",
        "name" => "slack",
        "modifier" => "replace:summary:hoge"
      }
      calendar  ={
        "id" => "3",
        "name" => "calendar",
        "modifier" => "stdout",
      }
      mail  ={
        "id" => "4",
        "name" => "mail",
        "modifier" => "stdout",
      }

      actions = []
      actions << stdout << slack << calendar << mail
      kvs.store("actions", actions.to_json)
    end
  end# class Action
end# module Goohub
