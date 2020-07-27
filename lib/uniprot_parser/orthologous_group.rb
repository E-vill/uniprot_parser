#!/usr/bin/ruby
# coding: utf-8

module UniprotParser
  #Encapsulate all the information about orthology for one protein
  class Orthologous_group
    attr_reader :database, :id, :informations
    def initialize(database, id, informations)
      @database = database
      @id = id
      @informations = informations
    end
  end
end