# coding: utf-8
module Goohub
  class Action
    attr_accessor :name, :modifier, :action

    def initialize(name)
      kvs = Goohub::DataStore.create(:file)
      #kvs = Goohub::DataStore.create(:redis, {:host => "localhost", :port => "6379".to_i, :db => "0".to_i})
      #set_db(kvs) # for test data set
      actions = JSON.parse(kvs.load("actions"))
      actions.each { |action|
        @action = action if action["name"].match(/^#{name}$/)
      }
      @name = @action['name']
      @modifier = @action['modifier']
    end

    private

    #####################################################
    ### setting_methods
    #####################################################
    def set_db(kvs)
      stdout  ={
        "name" => "stdout",
        "modifier" => "replace:summary:hoge"
      }
      slack  ={
        "name" => "slack",
        "modifier" => "replace:summary:hoge"
      }
      calendar  ={
        "name" => "calendar",
        "modifier" => "stdout",
      }
      mail  ={
        "name" => "mail",
        "modifier" => "stdout",
      }

      actions = []
      actions << stdout << slack << calendar << mail
      kvs.store("actions", actions.to_json)
    end
  end# class Action
end# module Goohub
