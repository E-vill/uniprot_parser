# uniprot-parser

This ruby parser aims to help you to parse your uniprot txt files,
 this gem is based on the [uniprot documentation](http://web.expasy.org/docs/userman.html)



# Extract informations from proteome

To parse a local proteome file :
```ruby
require 'uniprot_parser'

list_of_all_protein_from_the_file = UniprotParser::parse('/path/to/UP000000.txt')

```

To parse the file with a progress bar (please note that to setup the verbose option slightly increase the treatment time) :
```ruby
require 'uniprot_parser'

list_of_all_protein_from_the_file = UniprotParser::parse('/path/to/UP000000.txt', verbose: true)

```

If you want to parse a big file (big proteom file for exemple) or if you want to parse only a certain part of the file
```ruby
require 'uniprot_parser'

#will extract the 201th (INCLUDED) to the 500th (INCLUDED)
list_of_all_protein_from_the_file = UniprotParser::parse('/path/to/UP000000.txt', offset: 200, limit: 300)

```

Our parser propose some methods to automatically download proteom and protein files.
Please note that there is no mechanisms to either check that the proteom or protein id really exists
and to check the file integrity
```ruby
require 'uniprot_parser'

list_of_all_protein_from_the_file = UniprotParser::download_and_parse('UP000005640')

```


# Proteome object manipulation

A proteome is basically considered as a list of proteins.
For exemple, let's find all the QN stretch from the human proteome 
```ruby
require 'uniprot_parser'

human_QNstretch = UniprotParser::download_and_parse('UP000005640').select{|e|e.sequence.match /(Q|N){7,}/ }


```

# Proteins object manipulation

To extract protein ID :
```ruby
#exemple for : ID   ADH_DROSE               Reviewed;         256 AA.
myprot.id 
#=> return 'ADH_DROSE'

```

To extract protein AC
```ruby
#exemple for #AC   Q9GN94; B4HXI2; P07163;
myprot.first_ac 
#=> return 'Q9GN94'
myprot.secondary_ac
#=> return ['B4HXI2','P07163']

```

To extract GO term
```ruby
#exemple for : DR   GO; GO:0005576; C:extracellular region; IEA:UniProtKB-SubCell.
myprot.go_term
#=> return a GO_term object
myprot.go_term[0].id
#=> return 'GO:0005576'
myprot.go_term[0].database
#=> 'UniProtKB-SubCell'
myprot.go_term[0].ontology_type
#=> return 'C'
myprot.go_term[0].description
#=> return 'extracellular region'
myprot.go_term[0].evidence
#=> return 'IEA'

```

To extract gene :
```ruby
# exemple for GN   Name=Acp70A; Synonyms=PAPB; ORFNames=GM25408;
myprot.gene
#=> return a gene object
myprot.gene.name
#=> return 'Acp70A'
myprot.gene.orf
#=> return 'GM25408'

```


To extract orthology :
```ruby
# return on orthologous group object,
# the cross referenced database for phylogenie are :
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
# exemple for DR   OrthoDB; EOG94QWM6; -.
myprot.orthology
# => return an orthologous_group object
puts myprot.orthology.database
# => return 'OrthoDB'
puts myprot.orthology.id
# => return 'EOG94QWM6'
puts myprot.orthology.information
# => return '-'

```
For more examples please refer to the documentation or test case in [spec/](https://github.com/E-vill/uniprot_parser/blob/master/spec/uniprot_parser_spec.rb) 


# License
The code source is available as open source under the terms of the [CeCILL-B License](http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt) (fully compatible with BSD license ).

