
module UniprotParser
  #Encapsulate all finromations about gene
  class Gene
    attr_reader :name, :orf

    #@param name [String] the gene's name
    #@param orf [String] the gene's orf ID
    def initialize(name, orf)
      @name = name
      @orf = orf
    end
  end
end