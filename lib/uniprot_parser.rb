#!/usr/bin/ruby
# coding: utf-8
require 'ruby-progressbar'
require 'open-uri'
require 'net/http'

require 'uniprot_parser/protein'
require 'uniprot_parser/gene'
require 'uniprot_parser/version'
require 'uniprot_parser/error'
require 'uniprot_parser/uniprot_file'
require 'uniprot_parser/pdb_structure'

#The uniprot parser allow you to parse uniprot flat text file
# @author Etienne VILLAIN (etienne.villain@crbm.cnrs.fr)
module UniprotParser

  # Parse the uniprot flat file file pass in parameter.
  # @param file [String] the path to the file to parse or directly the file object
  # @return [Array<Protein>] an Array of Protein object
  def self.parse(file, verbose: false, offset: 0, limit: 0)

    raise ArgumentError.new 'offset should be a positive integer' if offset < 0
    raise ArgumentError.new 'limit should be a positive integer (0 means no limit)' if offset < 0

    temp_protein = Protein.new
    store = Array.new
    file = File.absolute_path(file.path)if file.class == File

    raise IOError.new "file #{File} does not exists" unless File.exist? file

    total = 0

    if(verbose)

      File.open(file,'r').each{|line| total += 1 if line[0..1] == '//'}

      total = (limit.to_i > 0) ? [total,limit.to_i].min : total
      total -= offset

      @pBar = ProgressBar.create( :format         => '%a %bᗧ%i %p%% %t',
                                 :progress_mark  => ' ',
                                 :remainder_mark => '･',
                                 :starting_at    => 0,
                                 :total => total)
    end

    offset_count = 0
    limit_count = 0
    File.open(file,'r').each do |line|

      if(offset_count < offset.to_i)
        offset_count += 1 if line[0..1] == '//'
        next
      end


      case line[0..1]
        when '  '
          temp_protein.append_seq(line)
        when '//'
          store << temp_protein
          temp_protein = Protein.new
          limit_count += 1
          @pBar.increment if(verbose)
          return store if(store.size == limit.to_i && limit.to_i > 0)
        else
          temp_protein.send("append_#{line[0..1].downcase}",line)
      end
    end
    return store
  end

  #Download the file from the uniprot server
  # @param id [String] the protein or proteom id
  # @param file_destination [String] if you wan't to keep the downloaded file set a path different than nil
  def self.get_file(id, file_destination: nil)

     raise NetworkDownError.new "Can't reach http://www.uniprot.org/" unless open("http://www.uniprot.org/")
   
    type_request = nil
    if(id.match /^UP[0-9]{9}/)
      type_request = :proteom
      #OLD format request = "http://www.uniprot.org/uniprot/?query=proteome:#{id}&compress=no&force=true&format=txt"
      request = "https://www.uniprot.org/uniprot/?include=false&format=txt&force=true&query=proteome:#{id}"
    elsif(id.match /[OPQ][0-9][A-Z0-9]{3}[0-9]|[A-NR-Z][0-9]([A-Z][A-Z0-9]{2}[0-9]){1,2}/)
      type_request = :protein
      request = "http://www.uniprot.org/uniprot/#{id}.txt"
    else
      raise ScriptError.new "Malformed ID : #{id}"
    end

    # we create the output file if needed and download the content
    file = ((file_destination.nil?) ? Tempfile.new(id).path : file_destination)
    download(request,file)
    return UniprotFile.new(file)
  end


  # Download the file corresponding to the ID and parse it
  # @param id [String] the protein or proteom id
  # @param file_destination [String] if you wan't to keep the downloaded file set a path different than nil
  def self.download_and_parse(id, file_destination: nil)
      file_destination = File.join(file_destination,"#{id}.txt") if ((!file_destination.nil? )&& File.directory?(file_destination))
      file = get_file(id, file_destination: file_destination)
      return file.parse
  end

  # Count the number of protein presents in the uniprot flat file file pass in parameter.
  # @param file [String] the path to the file to parse or directly the file object
  def self.count_protein(file)
    file = file.absolute_path(file.path)if file.class == File
    raise IOError.new "file #{File} does not exists" unless File.exist? file
    total = 0
    File.open(file,'r').each{|line| total += 1 if line[0..1] == '//'}
    return total
  end


  private
  def self.download(url, path)
    File.open(path, 'w+') do |f|
      IO.copy_stream(open(url), f)
    end
  end

end




