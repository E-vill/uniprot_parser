require 'uniprot_parser'

temp = UniprotParser::download_and_parse("UP000000327",file_destination: "temp")
p temp
