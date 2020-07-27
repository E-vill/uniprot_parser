require 'spec_helper'
require 'tempfile'

TEST_FILE_CONTENT_1 = <<"SEQ"
ID   A70A_DROSE              Reviewed;          55 AA.
AC   O18417; B4HGQ9;
DT   15-JUL-1998, integrated into UniProtKB/Swiss-Prot.
DT   01-JAN-1998, sequence version 1.
DT   22-JUL-2015, entry version 56.
DE   RecName: Full=Accessory gland-specific peptide 70A;
DE   AltName: Full=Paragonial peptide B;
DE   AltName: Full=Sex peptide;
DE            Short=SP;
DE   Flags: Precursor;
GN   Name=Acp70A; Synonyms=PAPB; ORFNames=GM25408;
OS   Drosophila sechellia (Fruit fly).
OC   Eukaryota; Metazoa; Ecdysozoa; Arthropoda; Hexapoda; Insecta;
OC   Pterygota; Neoptera; Endopterygota; Diptera; Brachycera; Muscomorpha;
OC   Ephydroidea; Drosophilidae; Drosophila; Sophophora.
OX   NCBI_TaxID=7238;
RN   [1]
RP   NUCLEOTIDE SEQUENCE [GENOMIC DNA].
RX   PubMed=9286679;
RA   Cirera S., Aguade M.N.;
RT   "Evolutionary history of the sex-peptide (Acp70A) gene region in
RT   Drosophila melanogaster.";
RL   Genetics 147:189-197(1997).
RN   [2]
RP   NUCLEOTIDE SEQUENCE [LARGE SCALE GENOMIC DNA].
RC   STRAIN=Rob3c / Tucson 14021-0248.25;
RX   PubMed=17994087; DOI=10.1038/nature06341;
RG   Drosophila 12 genomes consortium;
RT   "Evolution of genes and genomes on the Drosophila phylogeny.";
RL   Nature 450:203-218(2007).
CC   -!- FUNCTION: Represses female sexual receptivity and stimulates
CC       oviposition.
CC   -!- SUBCELLULAR LOCATION: Secreted.
CC   -!- TISSUE SPECIFICITY: Main cells of the accessory glands of males
CC       (paragonial gland).
CC   -----------------------------------------------------------------------
CC   Copyrighted by the UniProt Consortium, see http://www.uniprot.org/terms
CC   Distributed under the Creative Commons Attribution-NoDerivs License
CC   -----------------------------------------------------------------------
DR   EMBL; X99414; CAA67791.1; -; Genomic_DNA.
DR   EMBL; CH480815; EDW41367.1; -; Genomic_DNA.
DR   RefSeq; XP_002030381.1; XM_002030345.1.
DR   EnsemblMetazoa; FBtr0208393; FBpp0206885; FBgn0012779.
DR   GeneID; 6605559; -.
DR   KEGG; dse:Dsec_GM25408; -.
DR   FlyBase; FBgn0012779; Dsec\Acp70A.
DR   OMA; PNPRDKW; -.
DR   OrthoDB; EOG7034M7; -.
DR   PhylomeDB; O18417; -.
DR   Proteomes; UP000001292; Unassembled WGS sequence.
DR   GO; GO:0005576; C:extracellular region; IEA:UniProtKB-SubCell.
DR   GO; GO:0046008; P:regulation of female receptivity, post-mating; IEA:InterPro.
DR   InterPro; IPR012608; Sex_peptide.
DR   Pfam; PF08138; Sex_peptide; 1.
PE   2: Evidence at transcript level;
KW   Behavior; Complete proteome; Disulfide bond; Hydroxylation;
KW   Reference proteome; Secreted; Signal.
FT   SIGNAL        1     19       {ECO:0000250}.
FT   CHAIN        20     55       Accessory gland-specific peptide 70A.
FT                                /FTId=PRO_0000020588.
FT   MOD_RES      28     28       Hydroxyproline. {ECO:0000250}.
FT   MOD_RES      32     32       Hydroxyproline. {ECO:0000250}.
FT   MOD_RES      34     34       Hydroxyproline. {ECO:0000250}.
FT   MOD_RES      38     38       Hydroxyproline. {ECO:0000250}.
FT   DISULFID     43     55       {ECO:0000250}.
SQ   SEQUENCE   55 AA;  6438 MW;  E87AD0919657A83D CRC64;
     MKTLSVFLVL VCLLGLVQSW EWPWNRQPTR YPIPSPNPRD KWCRLNLGPA WGGRC
//
SEQ

ID_LINE_1 = <<"SEQ"
ID   A70A_DROSE              Reviewed;          55 AA.
SEQ

AC_LINE_1= <<"SEQ"
AC   O18417; B4HGQ9;
SEQ

DT_LINE_1= <<"SEQ"
DT   15-JUL-1998, integrated into UniProtKB/Swiss-Prot.
DT   01-JAN-1998, sequence version 1.
DT   22-JUL-2015, entry version 56.
SEQ

DE_LINE_1= <<"SEQ"
DE   RecName: Full=Accessory gland-specific peptide 70A;
DE   AltName: Full=Paragonial peptide B;
DE   AltName: Full=Sex peptide;
DE            Short=SP;
DE   Flags: Precursor;
SEQ

GN_LINE_1= <<"SEQ"
GN   Name=Acp70A; Synonyms=PAPB; ORFNames=GM25408;
SEQ

OS_LINE_1= <<"SEQ"
OS   Drosophila sechellia (Fruit fly).
SEQ

OC_LINE_1= <<"SEQ"
OC   Eukaryota; Metazoa; Ecdysozoa; Arthropoda; Hexapoda; Insecta;
OC   Pterygota; Neoptera; Endopterygota; Diptera; Brachycera; Muscomorpha;
OC   Ephydroidea; Drosophilidae; Drosophila; Sophophora.
SEQ

OX_LINE_1= <<"SEQ"
OX   NCBI_TaxID=7238;
SEQ

REF_LINE_1= <<"SEQ"
RN   [1]
RP   NUCLEOTIDE SEQUENCE [GENOMIC DNA].
RX   PubMed=9286679;
RA   Cirera S., Aguade M.N.;
RT   "Evolutionary history of the sex-peptide (Acp70A) gene region in
RT   Drosophila melanogaster.";
RL   Genetics 147:189-197(1997).
RN   [2]
RP   NUCLEOTIDE SEQUENCE [LARGE SCALE GENOMIC DNA].
RC   STRAIN=Rob3c / Tucson 14021-0248.25;
RX   PubMed=17994087; DOI=10.1038/nature06341;
RG   Drosophila 12 genomes consortium;
RT   "Evolution of genes and genomes on the Drosophila phylogeny.";
RL   Nature 450:203-218(2007).
SEQ

CC_LINE_1= <<"SEQ"
CC   -!- FUNCTION: Represses female sexual receptivity and stimulates
CC       oviposition.
CC   -!- SUBCELLULAR LOCATION: Secreted.
CC   -!- TISSUE SPECIFICITY: Main cells of the accessory glands of males
CC       (paragonial gland).
CC   -----------------------------------------------------------------------
CC   Copyrighted by the UniProt Consortium, see http://www.uniprot.org/terms
CC   Distributed under the Creative Commons Attribution-NoDerivs License
CC   -----------------------------------------------------------------------
SEQ

DR_LINE_1= <<"SEQ"
DR   EMBL; X99414; CAA67791.1; -; Genomic_DNA.
DR   EMBL; CH480815; EDW41367.1; -; Genomic_DNA.
DR   RefSeq; XP_002030381.1; XM_002030345.1.
DR   EnsemblMetazoa; FBtr0208393; FBpp0206885; FBgn0012779.
DR   GeneID; 6605559; -.
DR   KEGG; dse:Dsec_GM25408; -.
DR   FlyBase; FBgn0012779; Dsec\Acp70A.
DR   OMA; PNPRDKW; -.
DR   OrthoDB; EOG7034M7; -.
DR   PhylomeDB; O18417; -.
DR   Proteomes; UP000001292; Unassembled WGS sequence.
DR   GO; GO:0005576; C:extracellular region; IEA:UniProtKB-SubCell.
DR   GO; GO:0046008; P:regulation of female receptivity, post-mating; IEA:InterPro.
DR   InterPro; IPR012608; Sex_peptide.
DR   Pfam; PF08138; Sex_peptide; 1.
SEQ

PE_LINE_1= <<"SEQ"
PE   2: Evidence at transcript level;
SEQ

KW_LINE_1= <<"SEQ"
KW   Behavior; Complete proteome; Disulfide bond; Hydroxylation;
KW   Reference proteome; Secreted; Signal.
SEQ

FT_LINE_1 = <<"SEQ"
FT   SIGNAL        1     19       {ECO:0000250}.
FT   CHAIN        20     55       Accessory gland-specific peptide 70A.
FT                                /FTId=PRO_0000020588.
FT   MOD_RES      28     28       Hydroxyproline. {ECO:0000250}.
FT   MOD_RES      32     32       Hydroxyproline. {ECO:0000250}.
FT   MOD_RES      34     34       Hydroxyproline. {ECO:0000250}.
FT   MOD_RES      38     38       Hydroxyproline. {ECO:0000250}.
FT   DISULFID     43     55       {ECO:0000250}.
SEQ

SQ_LINE_1 = <<"SEQ"
SQ   SEQUENCE   55 AA;  6438 MW;  E87AD0919657A83D CRC64;
SEQ

SEQ_LINE_1 = <<"SEQ"
     MKTLSVFLVL VCLLGLVQSW EWPWNRQPTR YPIPSPNPRD KWCRLNLGPA WGGRC
SEQ

TEST_FILE_CONTENT_2 = <<"SEQ"
ID   ADH_DROSE               Reviewed;         256 AA.
AC   Q9GN94; B4HXI2; P07163;
DT   01-APR-1988, integrated into UniProtKB/Swiss-Prot.
DT   23-JAN-2007, sequence version 3.
DT   13-APR-2016, entry version 74.
DE   RecName: Full=Alcohol dehydrogenase;
DE            EC=1.1.1.1;
GN   Name=Adh; ORFNames=GM15656;
OS   Drosophila sechellia (Fruit fly).
OC   Eukaryota; Metazoa; Ecdysozoa; Arthropoda; Hexapoda; Insecta;
OC   Pterygota; Neoptera; Endopterygota; Diptera; Brachycera; Muscomorpha;
OC   Ephydroidea; Drosophilidae; Drosophila; Sophophora.
OX   NCBI_TaxID=7238;
RN   [1]
RP   NUCLEOTIDE SEQUENCE [GENOMIC DNA].
RA   Coyne J.A., Kreitman M.;
RT   "Evolutionary genetics of two sibling species, Drosophila simulans and
RT   D. sechellia.";
RL   Evolution 40:673-691(1985).
RN   [2]
RP   NUCLEOTIDE SEQUENCE [LARGE SCALE GENOMIC DNA].
RC   STRAIN=Rob3c / Tucson 14021-0248.25;
RX   PubMed=17994087; DOI=10.1038/nature06341;
RG   Drosophila 12 genomes consortium;
RT   "Evolution of genes and genomes on the Drosophila phylogeny.";
RL   Nature 450:203-218(2007).
RN   [3]
RP   NUCLEOTIDE SEQUENCE [GENOMIC DNA] OF 32-220.
RC   STRAIN=24, and SS77;
RX   PubMed=11102384;
RA   Kliman R.M., Andolfatto P., Coyne J.A., Depaulis F., Kreitman M.,
RA   Berry A.J., McCarter J., Wakeley J., Hey J.;
RT   "The population genetics of the origin and divergence of the
RT   Drosophila simulans complex species.";
RL   Genetics 156:1913-1931(2000).
CC   -!- CATALYTIC ACTIVITY: An alcohol + NAD(+) = an aldehyde or ketone +
CC       NADH. {ECO:0000255|PROSITE-ProRule:PRU10001}.
CC   -!- SUBUNIT: Homodimer.
CC   -!- SIMILARITY: Belongs to the short-chain dehydrogenases/reductases
CC       (SDR) family. {ECO:0000305}.
CC   -----------------------------------------------------------------------
CC   Copyrighted by the UniProt Consortium, see http://www.uniprot.org/terms
CC   Distributed under the Creative Commons Attribution-NoDerivs License
CC   -----------------------------------------------------------------------
DR   EMBL; X04672; CAA28377.1; -; Genomic_DNA.
DR   EMBL; CH480818; EDW51762.1; -; Genomic_DNA.
DR   EMBL; AF284480; AAG28713.1; -; Genomic_DNA.
DR   EMBL; AF284481; AAG28714.1; -; Genomic_DNA.
DR   PIR; S07439; S07439.
DR   RefSeq; XP_002035839.1; XM_002035803.1.
DR   ProteinModelPortal; Q9GN94; -.
DR   SMR; Q9GN94; 2-256.
DR   EnsemblMetazoa; FBtr0198641; FBpp0197133; FBgn0012780.
DR   GeneID; 6611292; -.
DR   KEGG; dse:Dsec_GM15656; -.
DR   FlyBase; FBgn0012780; Dsec\Adh.
DR   KO; K00001; -.
DR   OMA; PKVTITF; -.
DR   OrthoDB; EOG7966HT; -.
DR   PhylomeDB; Q9GN94; -.
DR   Proteomes; UP000001292; Unassembled WGS sequence.
DR   GO; GO:0004022; F:alcohol dehydrogenase (NAD) activity; IEA:UniProtKB-EC.
DR   GO; GO:0006066; P:alcohol metabolic process; IEA:InterPro.
DR   Gene3D; 3.40.50.720; -; 1.
DR   InterPro; IPR002425; ADH_Drosophila-type.
DR   InterPro; IPR002424; ADH_insect.
DR   InterPro; IPR016040; NAD(P)-bd_dom.
DR   InterPro; IPR020904; Sc_DH/Rdtase_CS.
DR   InterPro; IPR002347; SDR_fam.
DR   PANTHER; PTHR24322; PTHR24322; 2.
DR   Pfam; PF00106; adh_short; 1.
DR   PRINTS; PR01168; ALCDHDRGNASE.
DR   PRINTS; PR01167; INSADHFAMILY.
DR   PRINTS; PR00080; SDRFAMILY.
DR   SUPFAM; SSF51735; SSF51735; 1.
DR   PROSITE; PS00061; ADH_SHORT; 1.
PE   3: Inferred from homology;
KW   Complete proteome; NAD; Oxidoreductase; Reference proteome.
FT   INIT_MET      1      1       Removed.
FT   CHAIN         2    256       Alcohol dehydrogenase.
FT                                /FTId=PRO_0000054493.
FT   NP_BIND      12     35       NAD. {ECO:0000250}.
FT   ACT_SITE    153    153       Proton acceptor. {ECO:0000255|PROSITE-
FT                                ProRule:PRU10001}.
FT   BINDING     140    140       Substrate. {ECO:0000250}.
SQ   SEQUENCE   256 AA;  27745 MW;  2BEC8BDBFFD7E00B CRC64;
     MAFTLTNKNV IFVAGLGGIG LDTSKELLKR DLKNLVILDR IENPAAIAEL KAINPKVTVT
     FYPYDVTVPI AETTKLLKTI FAKLKTVDVL INGAGILDDH QIERTIAVNY TGLVNTTTAI
     LDFWDKRKGG PGGIICNIGS VTGFNAIYQV PVYSGTKAAV VNFTSSLAKL APITGVTAYT
     VNPGITRTTL VHKFNSWLDV EPQVAEKLLA HPTQPSLACA ENFVKAIELN QNGAIWKLDL
     GTLEAIQWTK HWDSGI
//
SEQ

TEST_FILE_CONTENT_3 = <<"SEQ"

SEQ


describe UniprotParser do

  #generic test.rb
  it 'has a version number' do
    expect(UniprotParser::VERSION).not_to be nil
  end



  #############################################################################
  ################################## ID line ##################################
  #############################################################################
  #exemple :
  #ID   ADH_DROSE               Reviewed;         256 AA.


  it 'extract the complete id line from txt file' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].id_block).to eq(ID_LINE_1.strip)
    tmp.close!
  end

  it 'extract id from txt file' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].id).to eq('A70A_DROSE')
    tmp.close!
  end

  it 'extract review status from one protein txt file' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].reviewed?).to eq(true)
    tmp.close!
  end


  #############################################################################
  ################################## AC line ##################################
  #############################################################################
  #exemple :
  #AC   Q9GN94; B4HXI2; P07163;

  it 'extract all the AC part' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].ac_block).to eq(AC_LINE_1.strip)
    tmp.close!
  end


  it 'extract primary accession number from txt file' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].first_ac).to eq('O18417')
    tmp.close!
  end

  it 'extract secondary accession number from txt file' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_2
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].secondary_ac).to eq(%w{B4HXI2 P07163})
    tmp.close!
  end

  #############################################################################
  ################################## DT line ##################################
  #############################################################################
  #exemple :
  #DT   15-JUL-1998, integrated into UniProtKB/Swiss-Prot.
  #DT   01-JAN-1998, sequence version 1.
  #DT   22-JUL-2015, entry version 56

  it 'extract all dt line' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].dt_block).to eq(DT_LINE_1.strip)
    tmp.close!
  end

  it 'correctly parse the integration date' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].dt_block).to eq(DT_LINE_1.strip)
    tmp.close!
  end


  it 'extract the date of the integration in base' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].date_integration).to eq(Date.parse('15-JUL-1998'))
    tmp.close!
  end

  it 'extract the date of the last sequence modification' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].date_last_modification_sequence).to eq(Date.parse('01-JAN-1998'))
    tmp.close!
  end

  it 'extract the date of the last modification other than data' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].date_last_modification_data).to eq(Date.parse('22-JUL-2015'))
    tmp.close!
  end

  it 'extract the version number of the sequence' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].sequence_version).to eq(1)
    tmp.close!
  end

  it 'extract the version number of the entry' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].entry_version_number).to eq(56)
    tmp.close!
  end


  #############################################################################
  ################################## DE line ##################################
  #############################################################################

  it 'extract the complete DE part' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].de_block).to eq(DE_LINE_1.strip)
    tmp.close!
  end

  it 'extract the full recommended name' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].name).to eq('Accessory gland-specific peptide 70A')
    tmp.close!
  end


  #############################################################################
  ################################## GN line ##################################
  #############################################################################

  it 'extract the complete GN part' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].gn_block).to eq(GN_LINE_1.strip)
    tmp.close!
  end

  #############################################################################
  ################################## OS line ##################################
  #############################################################################

  it 'extract the complete OS part' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].os_block).to eq(OS_LINE_1.strip)
    tmp.close!
  end

  #############################################################################
  ################################## OC line ##################################
  #############################################################################

  it 'extract the complete OC part' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].oc_block).to eq(OC_LINE_1.strip)
    tmp.close!
  end

  #############################################################################
  ################################## OX line ##################################
  #############################################################################

  it 'extract the complete OX part' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].ox_block).to eq(OX_LINE_1.strip)
    tmp.close!
  end

  #############################################################################
  ################################## Ref line ##################################
  #############################################################################

  it 'extract the Ref line' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].ref_block).to eq(REF_LINE_1.strip)
    tmp.close!
  end


  #############################################################################
  ################################## CC line ##################################
  #############################################################################

  it 'extract the CC line' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].cc_block).to eq(CC_LINE_1.strip)
    tmp.close!
  end

  #############################################################################
  ################################## DR line ##################################
  #############################################################################
  #exemple :
  #DR   EMBL; AF284480; AAG28713.1; -; Genomic_DNA.
  #DR   EMBL; AF284481; AAG28714.1; -; Genomic_DNA.
  #DR   PIR; S07439; S07439.
  #DR   RefSeq; XP_002035839.1; XM_002035803.1.
  #DR   ProteinModelPortal; Q9GN94; -.
  #DR   SMR; Q9GN94; 2-256.
  #DR   EnsemblMetazoa; FBtr0198641; FBpp0197133; FBgn0012780.
  #DR   GeneID; 6611292; -.
  #DR   KEGG; dse:Dsec_GM15656; -.
  #DR   FlyBase; FBgn0012780; Dsec\Adh.
  #DR   KO; K00001; -.
  #DR   OMA; PKVTITF; -.
  #DR   OrthoDB; EOG7966HT; -.
  #DR   PhylomeDB; Q9GN94; -.
  #DR   Proteomes; UP000001292; Unassembled WGS sequence.
  #DR   GO; GO:0004022; F:alcohol dehydrogenase (NAD) activity; IEA:UniProtKB-EC.
  #DR   GO; GO:0006066; P:alcohol metabolic process; IEA:InterPro.
  #DR   Gene3D; 3.40.50.720; -; 1.
  #DR   InterPro; IPR002425; ADH_Drosophila-type.
  #DR   InterPro; IPR002424; ADH_insect.
  #DR   InterPro; IPR016040; NAD(P)-bd_dom.
  #DR   InterPro; IPR020904; Sc_DH/Rdtase_CS.
  #DR   InterPro; IPR002347; SDR_fam.
  #DR   PANTHER; PTHR24322; PTHR24322; 2.
  #DR   Pfam; PF00106; adh_short; 1.
  #DR   PRINTS; PR01168; ALCDHDRGNASE.
  #DR   PRINTS; PR01167; INSADHFAMILY.
  #DR   PRINTS; PR00080; SDRFAMILY.
  #DR   SUPFAM; SSF51735; SSF51735; 1.
  #DR   PROSITE; PS00061; ADH_SHORT; 1.

  it 'extract the complete DR part' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].dr_block).to eq(DR_LINE_1.strip)
    tmp.close!
  end

  it 'extract pfam fields' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].dr_pfam).to eq(['PF08138; Sex_peptide; 1.'])
    tmp.close!
  end

  ## GO term

  it 'extract all the GO terms' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp << TEST_FILE_CONTENT_2
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].go_term.size).to eq(2)
    expect(UniprotParser::parse(tmp)[1].go_term.size).to eq(2)
    tmp.close!
  end


  it 'extract the go term id even for multiple entry' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp << TEST_FILE_CONTENT_2
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].go_term[0].id).to eq('GO:0005576')
    expect(UniprotParser::parse(tmp)[0].go_term[1].id).to eq('GO:0046008')
    expect(UniprotParser::parse(tmp)[1].go_term[0].id).to eq('GO:0004022')
    expect(UniprotParser::parse(tmp)[1].go_term[1].id).to eq('GO:0006066')
    tmp.close!
  end


  it 'extract the go term ontology type even for multiple entry' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp << TEST_FILE_CONTENT_2
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].go_term[0].ontology_type).to eq('C')
    expect(UniprotParser::parse(tmp)[0].go_term[1].ontology_type).to eq('P')
    expect(UniprotParser::parse(tmp)[1].go_term[0].ontology_type).to eq('F')
    expect(UniprotParser::parse(tmp)[1].go_term[1].ontology_type).to eq('P')
    tmp.close!
  end

  it 'extract the go term description even for multiple entry' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp << TEST_FILE_CONTENT_2
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].go_term[0].description).to eq('extracellular region')
    expect(UniprotParser::parse(tmp)[0].go_term[1].description).to eq('regulation of female receptivity, post-mating')
    expect(UniprotParser::parse(tmp)[1].go_term[0].description).to eq('alcohol dehydrogenase (NAD) activity')
    expect(UniprotParser::parse(tmp)[1].go_term[1].description).to eq('alcohol metabolic process')
    tmp.close!
  end


  it 'extract the go term code of evidence even for multiple entry' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp << TEST_FILE_CONTENT_2
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].go_term[0].evidence).to eq('IEA')
    expect(UniprotParser::parse(tmp)[0].go_term[1].evidence).to eq('IEA')
    expect(UniprotParser::parse(tmp)[1].go_term[0].evidence).to eq('IEA')
    expect(UniprotParser::parse(tmp)[1].go_term[1].evidence).to eq('IEA')
    tmp.close!
  end


  it 'extract the go term database even for multiple entry' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp << TEST_FILE_CONTENT_2
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].go_term[0].database).to eq('UniProtKB-SubCell')
    expect(UniprotParser::parse(tmp)[0].go_term[1].database).to eq('InterPro')
    expect(UniprotParser::parse(tmp)[1].go_term[0].database).to eq('UniProtKB-EC')
    expect(UniprotParser::parse(tmp)[0].go_term[1].database).to eq('InterPro')
    tmp.close!
  end

  ## Phylogenetic database

  it 'extract all the pylogenetic related cross referenced informations' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].orthology.size).to eq(3)
    tmp.close!
  end

  it 'extract all the ID from pylogenetic informations' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].orthology[0].id).to eq('PNPRDKW')
    tmp.close!
  end

  it 'extract all the ID from pylogenetic informations' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].orthology[0].database).to eq('OMA')
    tmp.close!
  end

  it 'extract all the content of the free informations field from pylogenetic informations' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].orthology[0].informations).to eq('-')
    tmp.close!
  end

  #############################################################################
  ################################## PE line ##################################
  #############################################################################

  it 'extract the PE line' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].pe_block).to eq(PE_LINE_1.strip)
    tmp.close!
  end


  #############################################################################
  ################################## KW line ##################################
  #############################################################################

  it 'extract the KW line' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].kw_block).to eq(KW_LINE_1.strip)
    tmp.close!
  end

  #############################################################################
  ################################## FT line ##################################
  #############################################################################

  it 'extract the FT line' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].ft_block).to eq(FT_LINE_1.strip)
    tmp.close!
  end

  #############################################################################
  ################################## SQ line ##################################
  #############################################################################
  #exemple :
  #SQ   SEQUENCE   55 AA;  6438 MW;  E87AD0919657A83D CRC64;

  it 'extract the sq line' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].sq_block).to eq(SQ_LINE_1.strip)
    tmp.close!
  end

  #############################################################################
  ################################## sequence #################################
  #############################################################################
  #exemple :
  #MKTLSVFLVL VCLLGLVQSW EWPWNRQPTR YPIPSPNPRD KWCRLNLGPA WGGRC

  it 'extract the complete sequence block' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].seq_block).to eq(SEQ_LINE_1.strip)
    tmp.close!
  end

  it 'extract the sequence' do
    tmp = Tempfile.new('well_formed_St_file.txt')
    tmp << TEST_FILE_CONTENT_1
    tmp.flush
    expect(UniprotParser::parse(tmp)[0].sequence).to eq(SEQ_LINE_1.strip.gsub(' ',''))
    tmp.close!
  end

  it 'can directly download the file to parse' do
    tmp = UniprotParser::download_and_parse('Q9GN94', file_destination: '/tmp/ADH_DROSE.txt')
    expect(tmp).not_to be_nil
  end

end
