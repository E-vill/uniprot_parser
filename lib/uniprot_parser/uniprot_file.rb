require 'tempfile'
require 'uniprot_parser'

module UniprotParser

  class UniprotFile
    def initialize(path)
      @path = path
    end

    # Parse the content of the file
    #@return all the protein object contained in the file
    def parse(verbose: false, offset: 0, limit: 0)
      @parsed_content = (@parsed_content.nil?) ? UniprotParser::parse(@path,verbose: verbose, offset: offset, limit: limit) : @parsed_content
      return @parsed_content
    end

    #@return the number of protein in the file
    def size
      if @size.nil?
        if(@parsed_content.nil?)
          @size = 0
          File.open(@path,'r').each do |line|
            @size += 1 if(line.match /ID\s+\S+\s+((Reviewed)|(Unreviewed));\s+\d+ AA\./)
          end
        else
          @size = (@parsed_content.is_a? Array) ? @parsed_content.size : 1
        end
      end
      return @size
    end
  end

end