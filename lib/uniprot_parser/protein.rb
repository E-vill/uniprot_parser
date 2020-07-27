#!/usr/bin/ruby
# coding: utf-8
require 'date'
require_relative './gene'
require_relative './orthologous_group'
require_relative './go_term'

module UniprotParser
  #Encapsulate all the information about one protein
  class Protein

    # Parse ID line
    #@example ID line to parse
    # - ID   UB222_WSSVS             Reviewed;         844 AA.
    # - ID   Q8VBA6_WSSVS            Unreviewed;        60 AA.
    REGEXP_ID = Regexp.compile(/^ID\s+(\S+)\s+((?:Unreviewed)|(?:Reviewed));.*/)

    # Parse gene onthology
    #@example GO line to parse
    # - DR   GO; GO:0016874; F:ligase activity; IEA:UniProtKB-KW.
    # - DR   GO; GO:0008270; F:zinc ion binding; IEA:InterPro.
    REGEXP_GO = Regexp.compile(/(GO:[^;]+);\s*([^:]+):([^;]+);\s*([^:]+):(.*)\./)

    #Parse generic DR lines
    REGEXP_DR_BASE = Regexp.compile(/\s*([^;]+);\s*(.+)\./)

    #Extract the FULL recommended name
    #@example DE lines :
    #DE   RecName: Full=Granulocyte colony-stimulating factor;
    #DE            Short=G-CSF;
    #DE   AltName: Full=Pluripoietin;
    REGEXP_NAME = Regexp.compile(/^DE   (?:(?:SubName)|(?:RecName)): Full=([^;]+);/)


    #Append a reference line (RN, RP, Rc, RX ...)
    #@param line [String] the ref line to append
    def append_ref(line)
      @ref_block = '' if @ref_block.nil?
      @ref_block += line
    end
    alias_method :append_rn, :append_ref
    alias_method :append_rp, :append_ref
    alias_method :append_rc, :append_ref
    alias_method :append_rx, :append_ref
    alias_method :append_rg, :append_ref
    alias_method :append_ra, :append_ref
    alias_method :append_rt, :append_ref
    alias_method :append_rl, :append_ref

    #Append a cross referenced database line (DR)
    #@param line [String] the DR line to append
    def append_dr(line)

      @dr_block = '' if @dr_block.nil?
      @dr_block += line
      @dr_hash = Hash.new if(@dr_hash.nil?)


      tmp = line.split(';')
      # we add the cross reference information in the dedicated hash
      # as key we use the ID of the database, as content the reference and other informations provided
      @dr_hash[tmp[0][2..-1].strip] = Array.new if(@dr_hash[tmp[0][2..-1].strip].nil?)
      @dr_hash[tmp[0][2..-1].strip] << tmp[1..-1].join(';').strip


      # we automatically create a method to get the database associated content
      unless respond_to? "dr_#{tmp[0][2..-1].gsub("\s",'').downcase}"
        #define_method is private so ...
        self.class.send(:define_method,"dr_#{tmp[0][2..-1].gsub("\s",'').downcase}") do ||
          return @dr_hash[tmp[0][2..-1].strip]
        end
      end
    end

    # Append a sequence line
    #@param line [String] the sequence line to append
    def append_seq(line)
      @seq_block = '' if @seq_block.nil?
      @seq_block += line
    end

    # Override Object.method_missing in a way to create
    # needed append_  and related accessor method to
    # manage diffrent type line
    def method_missing (m, *args)
      if m =~ /dr_\S+/
        return Array.new

      elsif(tmp = (m.to_s.match(/append_(..)/)))

        instance_variable_set("@#{tmp[1]}_block".to_sym, args[0])

        #create accessor
        self.class.send(:define_method,"#{tmp[1]}_block") do ||
          instance_variable_get("@#{tmp[1]}_block").strip
        end

        #create append_** method
        self.class.send(:define_method,"append_#{tmp[1]}") do |l|
          instance_variable_set("@#{tmp[1]}_block", '') unless instance_variable_defined? "@#{tmp[1]}_block"
          instance_variable_get("@#{tmp[1]}_block").insert -1, l
        end

      else
        super.method_missing(m, *args)
      end
    end

    ############ Specific accessor

    # To get all the articles reference block
    #@return [String] the complete reference block
    def ref_block
      return @ref_block.nil? ? '': @ref_block.strip
    end


    # To get all the articles reference block
    #@return [String] the complete sequence block
    def seq_block
      return @seq_block.nil? ? '': @seq_block.strip
    end


    # To get all the DR (database cross reference) block
    #@return [String] the DR block
    def dr_block
      return @dr_block.nil? ? '' : @dr_block.strip
    end


    # To get the sequence
    #@return [String] the sequence
    def sequence
      @sequence = '' if @sequence.nil?
      @sequence += @seq_block.gsub(/\s+|\n/,'')
    end

    # The protein ID
    #@return [String]
    def id
      @id = (@id_block.match REGEXP_ID)[1] if @id.nil?
      return @id
    end

    # The protein name
    #@return [String]
    def name
      @name = (@de_block.match REGEXP_NAME)[1] if @name.nil?
      return @name
    end

    #The review status
    #@return [Boolean] true if reviewed (manually curated), false otherwise
    def reviewed?
      @reviewed = (@id_block.match REGEXP_ID)[2] == 'Reviewed' if @reviewed.nil?
      return @reviewed
    end

    #The protein first AC
    #@return [String] the first AC of the protein
    def first_ac
      @first_ac = @ac_block.match(/^AC\s+([^;]+);.*/)[1] if @first_ac.nil?
      return @first_ac
    end

    #All the secondary AC
    #@return [Array<String>] all the secondary AC of the protein
    def secondary_ac
      if(@secondary_ac.nil?)
        @secondary_ac = Array.new
        list_ac = Array.new
        @ac_block.split("\n").each do |ac_line|
          list_ac.concat ac_line[2..-1].strip.split(';')
        end
        list_ac.map!{|e|e.strip}
      end
      @secondary_ac.concat list_ac[1..-1] if list_ac.size > 1

      return @secondary_ac
    end

    #@return [Date] sequence integration in the database date
    def date_integration
      if @date_integration.nil?
        @date_integration = Date.parse ((@dt_block.split("\n")[0].match /DT\s+([^,]+),.*/)[1])
      end
      @date_integration
    end

    #@return [Date] last time that sequence were modified
    def date_last_modification_sequence
      if @date_last_modification_sequence.nil?
        @date_last_modification_sequence = Date.parse ((@dt_block.split("\n")[1].match /DT\s+([^,]+),.*/)[1])
      end
      @date_last_modification_sequence
    end

    #@return [Date] last time that data (other than sequence) were modified
    def date_last_modification_data
      if @date_last_modification_data.nil?
        @date_last_modification_data = Date.parse ((@dt_block.split("\n")[2].match /DT\s+([^,]+),.*/)[1])
      end
      @date_last_modification_data
    end

    #@return [Integer] the version number (version number indicate how many times data other than the sequence was modified)
    def sequence_version
      if @sequence_version.nil?
        @sequence_version = (@dt_block.split("\n")[1].match /DT\s+[^,]+, sequence version (\d+)\./)[1].to_i
      end
      @sequence_version
    end

    #@return [Integer] the version number (version number indicate how many times data other than the sequence was modified)
    def entry_version_number
      if @entry_version_number.nil?
        @entry_version_number = (@dt_block.split("\n")[2].match /DT\s+[^,]+, entry version (\d+)\./)[1].to_i
      end
      @entry_version_number
    end

    #return [Integer] the protein existence level (how trustable the protein is, coming from experimental evidence or prediction like homology)
    def protein_existence
      if @protein_existence.nil?
        @protein_existence = (@pe_block.match /^PE\s+(\d):.*/)[1].to_i
      end
      @protein_existence
    end

    #@return [Array<Go_term>] the list of GO term associated with the protein
    def go_term
      ret = Array.new
      unless(@dr_hash['GO'].nil?)
        @dr_hash['GO'].each do |l|
          tmp = l.match(REGEXP_GO)
          ret << Go_term.new(tmp[1],tmp[2],tmp[3],tmp[4], tmp[5])
        end
      end
      return ret
    end

    #@return the list of gene-s that code for the protein
    def gene
      ret = Array.new
      unless @gn_block.nil?
        @gn_block.split("\n").each do |l|
          #if(tmp = l.match(/GN\s+Name=([^;]+);\s+ORFNames=([^;]+);/))
          if(tmp = l.match(/GN\s+Name=(\w+)\s*\S*;/)) #change regex so it collect only short gene name (not {ECO:0000255|HAMAP-Rule:MF_00445}, example with NU2C1_ORYSJ) and consider that ORFName are not always present (example with P53_HUMAN)
            orf = (temp = l.match(/ORFNames=([^;]+);/))? temp[1] : "unknown"
            ret << Gene.new(tmp[1],orf)
          end
        end
      end
      return ret
    end

    #@param specific_database [String] (optional) if you want only orthologous group from one specific database
    #@return [Array<orthologs_group>] the list of orthologs group in cross referenced databases dedicated to phylogeniy :
    # - eggNOG ex : DR   eggNOG; ENOG410IEUN; Eukaryota.
    # - GeneTree ex : DR   GeneTree; EMGT00050000006238; -.
    # - HOGEMON ex : DR   HOGENOM; HBG282443; -.
    # - HOVERGEN ex : DR   HOVERGEN; HBG057182; -.
    # - InParanoid ex : DR   InParanoid; O04196; -.
    # - KO ex : DR   KO; K09972; -.
    # - OMA ex : DR   OMA; GLCHYFS; -.
    # - OrthoDB ex : DR   OrthoDB; EOG94QWM6; -.
    # - PhylomeDB ex : DR   PhylomeDB; A4WFL4; -.
    # - TreeFam ex : DR   TreeFam; TF324882; -.
    def orthology( specific_database: ['eggNOG','GeneTree','HOGEMON', 'HOVERGEN', 'InParanoid', 'KO', 'OMA', 'OrthoDB' , 'PhylomeDB', 'TreeFam'])
      ret = Array.new
      ((specific_database.class == String || specific_database.class == Symbol) ? [specific_database] : specific_database).each  do |db|
        unless @dr_hash[db.to_s].nil?
        @dr_hash[db.to_s].each do |info|
          m = info.match REGEXP_DR_BASE
          ret << Orthologous_group.new(db.to_s,m[1],m[2])
        end
        end
      end
      return ret
    end

    #@return a list of all the pdb structure associated to this protein (list can be empty)
    def structure
      list_struct = Array.new
      return [] if dr_pdb().nil?
      dr_pdb().each do |struct|
        list_struct << PdbStructure.new(struct)
      end
      return list_struct
    end


  end
end
