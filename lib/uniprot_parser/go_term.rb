#!/usr/bin/ruby
# coding: utf-8

module UniprotParser
  #Encapsulate all the information about one go_term
  class Go_term
    attr_reader :id, :ontology_type, :description, :evidence, :database
    def initialize(id, ontology_type, description, evidence, database)
      @id =id
      @ontology_type = ontology_type
      @description = description
      @evidence = evidence
      @database = database
    end
  end
end