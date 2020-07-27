#!/usr/bin/ruby
# coding: utf-8

module UniprotParser
  #Encapsulate all the information about one pdb structure
  class PdbStructure
    attr_reader :id, :determination_method, :resolution, :chain
    def initialize dr_pdb_block
      # exemple : 1JLA; X-ray; 2.50 A; A=588-1147
      tmp = dr_pdb_block.split(';')
      @id = tmp[0]
      @determination_method = tmp[1]
      @resolution = tmp[2]
      @chain = tmp[3]
    end
  end
end