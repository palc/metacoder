#' Fungal ITS Genbank refseq
#'
#' A dataset containing information for 299 sequences obtained form NCBI using the following query:
#' 
#' \code{
#' (18s[All Fields] AND 28s[All Fields]) AND "basidiomycetes"[porgn] AND (refseq[filter] AND ("700"[SLEN] : "800"[SLEN]))
#' }
#' 
#' @examples
#' \dontrun{
#' 
#' file_path <- system.file("extdata", "ncbi_basidiomycetes.fasta", package = "metacoder")
#' sequences <- ape::read.FASTA(file_path)
#' genbank_ex_data <- extract_taxonomy(sequences,
#'                                     regex = "^.*\\|(.*)\\|.*\\|(.*)\\|(.*)$",
#'                                     key = c(gi_no = "obs_info", "obs_id", desc = "obs_info"),
#'                                     database = "ncbi")
#' }
#' @format An object of type \code{\link{taxmap}}
#' @source \url{http://www.ncbi.nlm.nih.gov/nuccore}
"genbank_ex_data"


#' Example dataset of comtamination
#'
#' A dataset containing information from 97 NCBI accession numbers representing possible contamination:
#' 
#' @examples
#' \dontrun{
#' 
#' ids <- c("JQ086376.1", "AM946981.2", "JQ182735.1", "CP001396.1", "J02459.1", 
#'          "AC150248.3", "X64334.1", "CP001509.3", "CP006698.1", "AC198536.1", 
#'          "JF340119.2", "KF771025.1", "CP007136.1", "CP007133.1", "U39286.1", 
#'          "CP006584.1", "EU421722.1", "U03462.1", "U03459.1", "AC198467.1", 
#'          "V00638.1", "CP007394.1", "CP007392.1", "HG941718.1", "HG813083.1", 
#'          "HG813082.1", "CP007391.1", "HG813084.1", "CP002516.1", "KF561236.1", 
#'          "JX509734.1", "AP010953.1", "U39285.1", "M15423.1", "X98613.1", 
#'          "CP006784.1", "CP007393.1", "CU928163.2", "AP009240.1", "CP007025.1", 
#'          "CP006027.1", "CP003301.1", "CP003289.1", "CP000946.1", "CP002167.1", 
#'          "HG428755.1", "JQ086370.1", "CP001846.1", "CP001925.1", "X99439.1", 
#'          "AP010958.1", "CP001368.1", "AE014075.1", "CP002212.1", "CP003034.1", 
#'          "CP000243.1", "AY940193.1", "CP004009.1", "JQ182732.1", "U02453.1", 
#'          "AY927771.1", "BA000007.2", "CP003109.1", "CP007390.1", "U02426.1", 
#'          "U02425.1", "CP006262.1", "HG738867.1", "U00096.3", "FN554766.1", 
#'          "CP001855.1", "L19898.1", "AE005174.2", "FJ188381.1", "AK157373.1", 
#'          "JQ182733.1", "U39284.1", "U37692.1", "AF129072.1", "FM180568.1", 
#'          "CP001969.1", "HE616528.1", "CP002729.1", "JF974339.1", "AB248924.1", 
#'          "AB248923.1", "CP002291.1", "X98409.1", "CU928161.2", "CP003297.1", 
#'          "FJ797950.1", "CP000038.1", "U82598.1", "CP002211.1", "JQ806764.1", 
#'          "U03463.1", "CP001665.1")
#' contaminants <- extract_taxonomy(ids, key = "obs_id", database = "ncbi")
#' }
#'
#' @format An object of type \code{\link{taxmap}}
"contaminants"


#' Example of UNITE fungal ITS data
#'
#' A dataset containing information from 449 sequences from the UNITE reference database.
#' 
#' @examples
#' \dontrun{
#' 
#' file_path <- system.file("extdata", "unite_general_release.fasta", package = "metacoder")
#' sequences <- ape::read.FASTA(file_path)
#' unite_ex_data_1 <- extract_taxonomy(sequences[!grepl(pattern = "\\|UDB", names(sequences))],
#'                                     regex = "^(.*)\\|(.*)\\|(.*)\\|.*\\|(.*)$",
#'                                     key = c(name = "obs_info", "obs_id",
#'                                             other_id = "obs_info", tax_string = "obs_info"),
#'                                     database = "ncbi")
#' }
#'
#' @format An object of type \code{\link{taxmap}}
#' @source \url{https://unite.ut.ee/}
"unite_ex_data_1"


#' Example of UNITE fungal ITS data
#'
#' A dataset containing information from 500 sequences from the UNITE reference database.
#' 
#' @examples
#' \dontrun{
#' 
#' file_path <- system.file("extdata", "unite_general_release.fasta", package = "metacoder")
#' sequences <- ape::read.FASTA(file_path)
#' unite_ex_data_2 <- extract_taxonomy(sequences,
#'                                     regex = "^(.*)\\|(.*)\\|(.*)\\|.*\\|(.*)$",
#'                                     key = c(seq_name = "obs_info", seq_id = "obs_info",
#'                                             other_id = "obs_info", "class"),
#'                                     class_regex = "^(.*)__(.*)$",
#'                                     class_key = c(unite_rank = "taxon_info", "name"),
#'                                     class_sep = ";",
#'                                     database = "ncbi")
#' }
#'
#' @format An object of type \code{\link{taxmap}}
#' @source \url{https://unite.ut.ee/}
"unite_ex_data_2"


#' Example of UNITE fungal ITS data
#'
#' A dataset containing information from 500 sequences from the UNITE reference database.
#' 
#' @examples
#' \dontrun{
#' 
#' file_path <- system.file("extdata", "unite_general_release.fasta", package = "metacoder")
#' sequences <- ape::read.FASTA(file_path)
#' unite_ex_data_3 <- extract_taxonomy(sequences,
#'                                     regex = "^(.*)\\|(.*)\\|(.*)\\|.*\\|(.*)$",
#'                                     key = c(seq_name = "obs_info", seq_id = "obs_info",
#'                                             other_id = "obs_info", "class"),
#'                                     class_regex = "^(.*)__(.*)$",
#'                                     class_key = c(unite_rank = "taxon_info", "name"),
#'                                     class_sep = ";")
#' }
#'
#' @format An object of type \code{\link{taxmap}}
#' @source \url{https://unite.ut.ee/}
"unite_ex_data_3"



#' Example of PR2 SSU data
#'
#' A dataset containing information from 249 Stramenopile sequences from the PR2 reference database.
#' 
#' @examples
#' \dontrun{
#' 
#' file_path <- system.file("extdata", "pr2_stramenopiles_gb203.fasta", package = "metacoder")
#' sequences <- ape::read.FASTA(file_path)
#' pr2_ex_data <- extract_taxonomy(sequences,
#'                                 regex = "^(.*\\..*?)\\|(.*)$",
#'                                 key = c("obs_id", "class"),
#'                                 class_sep = "\\|")
#' }
#'
#' @format An object of type \code{\link{taxmap}}
"pr2_ex_data"


#' Example of RDP Archea data
#'
#' A dataset containing information from 400 Archaea 16S sequences from the RDP reference database.
#' 
#' @examples
#' \dontrun{
#' 
#' file_path <- system.file("extdata", "rdp_current_Archaea_unaligned.fa", package = "metacoder")
#' sequences <- ape::read.FASTA(file_path)
#' rdp_ex_data <- extract_taxonomy(sequences,
#'                                 regex = "^(.*?) (.*)\\tLineage=(.*)",
#'                                 key = c(id = "obs_info", description = "obs_info", "class"),
#'                                 class_regex = "(.+?);(.*?);",
#'                                 class_key = c("name", "taxon_info"))
#' }
#'
#' @format An object of type \code{\link{taxmap}}
#' @source \url{https://rdp.cme.msu.edu/}
"rdp_ex_data"


#' Example of ITS1 fungal data
#'
#' A dataset containing information from 170 Chytridiomycota ITS sequences from the ITS1 reference database.
#' 
#' @examples
#' \dontrun{
#' 
#' file_path <- system.file("extdata", "its1_chytridiomycota_hmm.fasta", package = "metacoder")
#' sequences <- ape::read.FASTA(file_path)
#' its1_ex_data <- extract_taxonomy(sequences,
#'                                  regex = "^(.*)\\|(.*)\\|tax_id:(.*)\\|(.*)$",
#'                                  key = c("obs_id", taxon_name = "taxon_info",
#'                                          "taxon_id", description = "obs_info"),
#'                                  database = "ncbi")
#' }
#'
#' @format An object of type \code{\link{taxmap}}
"its1_ex_data"


#' Example dataset of bryophytes
#'
#' A dataset containing information from 171 bryophytes family names scraped from \url{http://www.theplantlist.org/1.1/browse/B/}:
#' 
#' @examples
#' \dontrun{
#' 
#' library(XML)
#' taxon_names <- XML::htmlTreeParse("http://www.theplantlist.org/1.1/browse/B/") %>% 
#' xmlRoot() %>%
#'   getNodeSet("//ul[@id='nametree']/li/a/i") %>%
#'   sapply(xmlValue)
#'   
#' bryophytes_ex_data <- extract_taxonomy(taxon_names, key = "name", database = "itis")
#' }
#'
#' @format An object of type \code{\link{taxmap}}
"bryophytes_ex_data"


#' Example dataset from SILVA
#'
#' https://www.arb-silva.de/
#' 
#' @examples
#' \dontrun{
#' 
#' file_path <- system.file("extdata", "silva_nr99.fasta", package = "metacoder")
#' sequences <- ape::read.FASTA(file_path)
#' silva_ex_data <- extract_taxonomy(sequences,
#'                                   regex = "^(.*?) (.*)$",
#'                                   key = c(id = "obs_info", "class"),
#'                                   class_sep = ";")
#' }
#'
#' @format An object of type \code{\link{taxmap}}
"silva_ex_data"

