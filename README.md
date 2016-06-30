[![Build Status](https://travis-ci.org/grunwaldlab/metacoder.png?branch=master)](https://travis-ci.org/grunwaldlab/metacoder?branch=master) [![codecov.io](https://codecov.io/github/grunwaldlab/metacoder/coverage.svg?branch=master)](https://codecov.io/github/grunwaldlab/metacoder?branch=master)

An R package for metabarcoding research planning and analysis
-------------------------------------------------------------

Metabarcoding is revolutionizing microbial ecology and presenting new challenges:

-   Numerous database formats make taxonomic data difficult to parse, combine, and subset.
-   Stacked bar charts, commonly used to depict community diversity, lack taxonomic context.
-   Barcode loci and primers are a source of under-explored bias.

MetacodeR is an R package that attempts to addresses these issues:

-   Sources of taxonomic data can be extracted from any file format and manipulated.
-   Community diversity can be visualized by color and size in a tree plot.
-   Primer specificity can be estimated with *in silico* PCR.

### Documentation

Documentation is under construction at <http://grunwaldlab.github.io/metacoder>.

### Download the current version

While this project is in development it can be installed through Github:

    devtools::install_github(repo="grunwaldlab/metacoder", build_vignettes = TRUE)
    library(metacoder)

If you've built the vignettes, you can browse them with:

    browseVignettes(package="metacoder")

### Dependencies

The function that runs *in silico* PCR requires `primersearch` from the EMBOSS tool kit to be installed. This is not an R package, so it is not automatically installed. Type `?primersearch` after installing and loading MetcodeR for installation instructions.

### Extracting taxonomic data

Most databases have a unique file format and taxonomic hierarchy/nomenclature. Taxonomic data can be extracted from any file format using the **extract\_taxonomy** function. Classifications can be parsed offline or retrieved from online databases if a taxon name, taxon ID, or sequence ID is present. A regular expression with capture groups and a corresponding key is used to define how to parse the file. The example code below parses the 16s Ribosome Database Project training set for Mothur.

R can be used to download files from the internet and decompress them. The code below downloads the compressed data to a temporary directory:

``` r
rdp_fasta_url <- "http://mothur.org/w/images/b/b5/Trainset10_082014.rdp.tgz"
temp_dir_path <- tempdir()
local_file_path <- file.path(temp_dir_path, basename(rdp_fasta_url))
download.file(url = rdp_fasta_url, destfile = local_file_path, quiet = TRUE)
```

Next we will uncompress the archive and identify the fasta file.

``` r
# Get contents of tar archive
unpacked_file_paths <- untar(local_file_path, list = TRUE)
# Uncompress archive
untar(local_file_path, exdir = temp_dir_path)
# Identify the Mothur RDP training set
unpacked_fasta_path <- file.path(temp_dir_path, 
                                  unpacked_file_paths[grepl("fasta$", unpacked_file_paths)])
```

The file can then be parsed using the `ape` package and the taxonomy data in the headers can be extracted by `extract_taxonomy`:

``` r
# Load the package
library(metacoder)
# Load the input FASTA file
seqs <- ape::read.FASTA(unpacked_fasta_path)
# Print an example of the sequence headers
cat(names(seqs)[1])
```

    ## AB294171_S001198039  Root;Bacteria;Firmicutes;Bacilli;Lactobacillales;Carnobacteriaceae;Alkalibacterium

``` r
# Extract the taxonomic information of the sequences
data <- extract_taxonomy(seqs, regex = "^(.*)\\t(.*)",
                         key = c(id = "obs_info", "class"),
                         class_sep = ";")
```

The resulting object contains sequence information associated with an inferred taxonomic hierarchy. The standard print method of the object shows a part of every kind of data it contains:

``` r
data
```

    ## `taxmap` object with data for 2794 taxa and 10650 observations:
    ## 
    ## --------------------------------------------------- taxa ---------------------------------------------------
    ## 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ... 2784, 2785, 2786, 2787, 2788, 2789, 2790, 2791, 2792, 2793, 2794
    ## 
    ## ------------------------------------------------ taxon_data ------------------------------------------------
    ## Source: local data frame [2,794 x 3]
    ## 
    ##    taxon_ids supertaxon_ids            name
    ##        <chr>          <chr>           <chr>
    ## 1          1             NA            Root
    ## 2          2              1         Archaea
    ## 3          3              1        Bacteria
    ## 4          4              2 "Crenarchaeota"
    ## 5          5              2 "Euryarchaeota"
    ## 6          6              2  "Korarchaeota"
    ## 7          7              2 "Nanoarchaeota"
    ## ..       ...            ...             ...
    ## 
    ## ------------------------------------------------- obs_data -------------------------------------------------
    ## Source: local data frame [10,650 x 3]
    ## 
    ##    obs_taxon_ids                  id
    ##            <chr>               <chr>
    ## 1           1289 AB294171_S001198039
    ## 2            369 AB243007_S000622964
    ## 3           2402 AJ717394_S000623308
    ## 4           1409 AJ518871_S000351779
    ## 5            962 CP000159_S000632736
    ## 6           1311   X76329_S000015720
    ## 7            616 AB184711_S000652435
    ## ..           ...                 ...
    ## Variables not shown: sequence <chr>.
    ## 
    ## ----------------------------------------------- taxon_funcs -----------------------------------------------
    ## n_obs, n_obs_1, taxon_levels, hierarchies

Note the `taxon_funcs` part contains function names (e.g. `n_obs`) used to calculate taxon statistics. You can see the results of these calculations using the `taxon_data` function:

``` r
taxon_data(data)
```

    ## Source: local data frame [2,794 x 7]
    ## 
    ##    taxon_ids supertaxon_ids              name n_obs n_obs_1 taxon_levels hierarchies
    ##        <chr>          <chr>             <chr> <dbl>   <dbl>        <dbl>       <chr>
    ## 1          1             NA              Root 10650       0            1           1
    ## 2          2              1           Archaea   410       0            2         1;2
    ## 3          3              1          Bacteria 10240       0            2         1;3
    ## 4          4              2   "Crenarchaeota"    55       0            3       1;2;4
    ## 5          5              2   "Euryarchaeota"   335       0            3       1;2;5
    ## 6          6              2    "Korarchaeota"    10      10            3       1;2;6
    ## 7          7              2   "Nanoarchaeota"     3       3            3       1;2;7
    ## 8          8              2 Nanohaloarchaeota     1       0            3       1;2;8
    ## 9          9              2  "Thaumarchaeota"     6       0            3       1;2;9
    ## 10        10              4      Thermoprotei    55       0            4    1;2;4;10
    ## ..       ...            ...               ...   ...     ...          ...         ...

There is corresponding `obs_data` function and `obs_funcs` list, but they are not used in this case.

### Metadiversity Plots

The hierarchical nature of taxonomic data makes it difficult to plot effectively. Most often, bar charts, stacked bar charts, or pie graphs are used, but these are ineffective when plotting many taxa or multiple ranks. MetacodeR maps taxonomic data (e.g. sequence abundance) to color/size of tree components in what we call a **Metadiversity Plot**:

``` r
plot(data, node_size = n_obs, node_label = name, node_color = n_obs)
```

![](README_files/figure-markdown_github/unnamed-chunk-9-1.png)

The default size range displayed is optimized for each plot. The legend represents the number of sequences for each taxon as both a color gradient and width of nodes. Only a few options are needed to make effective plots, yet many are available for customization of publication-ready graphics:

``` r
set.seed(8)
plot(data, node_size = n_obs, edge_color = taxon_levels,
     node_label = name, node_color = n_obs,
     node_color_range = c("cyan", "magenta", "green"),
     edge_color_range   = c("#555555", "#EEEEEE"),
     initial_layout = "reingold-tilford", layout = "davidson-harel",
     overlap_avoidance = 0.5)
```

![](README_files/figure-markdown_github/unnamed-chunk-11-1.png)

The above command can take several minutes since it uses a force-directed layout that requires simulations.

Note that `plot` is a generic R function that works differently depending on what it is given to it. MetacodeR supplies the function **plot\_taxonomy**, which is used when plot is given the type of data outputted by `extract_taxonomy`. To see the long list of available plotting options, type `?plot_taxonomy`.

### Subsetting

Taxonomic data in the form used in metacodeR can be manipulated using functions inspired by `dplyr`. For example, taxa can be subset using `filter_taxa`. Unlike the `dplyr` function `filter`, users can choose preserve or remove the subtaxa, supertaxa, and associated observation data of the selected taxa. For example, `filter_taxa` can be used to look at just the Archaea:

``` r
set.seed(1)
plot(filter_taxa(data, name == "Archaea", subtaxa = TRUE),
     node_size = n_obs, node_label = name, 
     node_color = n_obs, layout = "fruchterman-reingold")
```

![](README_files/figure-markdown_github/unnamed-chunk-13-1.png)

Any column displayed by `taxon_data` can be used with `filter_taxa` (and most other metacodeR commands) as if it were a variable on its own. To make the Archaea-Bacteria division more clear, the "Root" taxon can be removed, resulting in two separate trees:

``` r
subsetted <- filter_taxa(data, taxon_levels > 1)
set.seed(2)
plot(subsetted, node_size = n_obs, node_label = name,
     node_color = n_obs, tree_label = name)
```

![](README_files/figure-markdown_github/unnamed-chunk-15-1.png)

Although observations (information in `obs_data`) are typically assinged to the tips of the taxonomy, they can also be assigned to any internal node. When a taxon is removed by a filtering operation, the observations assinged to it are reassigned to an unfiltered supertaxon by default. This makes it easy to remove lower ranks of a taxonomy without discarding oberservations assinged to the tips:

``` r
set.seed(1)
filter_taxa(data, taxon_levels < 5) %>%
  plot(node_size = n_obs, node_label = name, node_color = n_obs)
```

![](README_files/figure-markdown_github/unnamed-chunk-17-1.png)

There is also a `filter_obs` function which can filter out observations and the taxa they are assigned to.

### Sampling

When calculating statistics for taxa, the amount of data should be balanced across taxa and there should be enough data per taxon to provide unbiased estimates. Random samples from large reference databases are biased towards overrepresented taxa. MetacodeR provides two ways to randomly sample taxonomic data. The function `taxonomic_sample` is used to create taxonomically balanced random samples. The acceptable range of sequence or subtaxa counts can be defined for each taxonomic rank; taxa with too few are excluded and taxa with too many are randomly subsampled. The code below samples the data such that rank 6 taxa will have 5 sequences and rank 3 taxa (phyla) will have less than 100:

``` r
set.seed(1)
sampled <- taxonomic_sample(subsetted, max_counts = c("3" = 100, "6" = 5), min_counts = c("6" = 5))
sampled <- filter_taxa(sampled, n_obs > 0, subtaxa = FALSE) 
```

``` r
set.seed(3)
plot(sampled, node_size = n_obs, node_label = n_obs, overlap_avoidance = 0.5,
     node_color = n_obs, tree_label = name)
```

![](README_files/figure-markdown_github/unnamed-chunk-19-1.png)

This can also be accomplished using the `dplyr` equivalents to `sample_n` and `sample_frac` by weighting the probability of sampling observations by the inverse of the number of observations:

``` r
set.seed(6)
sample_n_obs(subsetted, size = 1000, taxon_weight = 1 / n_obs, unobserved = FALSE) %>%
  plot(node_size = n_obs, node_label = n_obs, overlap_avoidance = 0.5,
       node_color = n_obs, tree_label = name)
```

![](README_files/figure-markdown_github/unnamed-chunk-21-1.png)

### In silico PCR

The function **primersearch** is a wrapper for an EMBOSS tool that implements *in silico* PCR. The code below estimates the coverage of the universal prokaryotic primer pair 515F/806R `citep("10.1128/mSystems.00009-15")`:

``` r
pcr <- primersearch(sampled, 
                    forward = c("515F" = "GTGYCAGCMGCCGCGGTAA"), 
                    reverse = c("806R" = "GGACTACNVGGGTWTCTAAT"), 
                    mismatch = 10)
taxon_data(pcr)
```

    ## Source: local data frame [898 x 9]
    ## 
    ##    taxon_ids supertaxon_ids              name n_obs n_obs_1 taxon_levels hierarchies count_amplified prop_amplified
    ##        <chr>          <chr>             <chr> <dbl>   <dbl>        <dbl>       <chr>           <dbl>          <dbl>
    ## 1          2             NA           Archaea   135       0            1           2             126      0.9333333
    ## 2          3             NA          Bacteria  1881       0            1           3            1596      0.8484848
    ## 3          4              2   "Crenarchaeota"    10       0            2         2;4              10      1.0000000
    ## 4          5              2   "Euryarchaeota"   105       0            2         2;5              99      0.9428571
    ## 5          6              2    "Korarchaeota"    10      10            2         2;6              10      1.0000000
    ## 6          7              2   "Nanoarchaeota"     3       3            2         2;7               0      0.0000000
    ## 7          8              2 Nanohaloarchaeota     1       0            2         2;8               1      1.0000000
    ## 8          9              2  "Thaumarchaeota"     6       0            2         2;9               6      1.0000000
    ## 9         10              4      Thermoprotei    10       0            3      2;4;10              10      1.0000000
    ## 10        14             10      Sulfolobales     5       0            4   2;4;10;14               5      1.0000000
    ## ..       ...            ...               ...   ...     ...          ...         ...             ...            ...

The proportion of sequences amplified can be represented by color in a metadiversity plot:

``` r
set.seed(3)
plot(pcr, node_size = n_obs, node_label = name,
     node_color = prop_amplified,
     node_color_range =  c("red", "orange", "yellow", "green", "cyan"),
     node_color_trans = "linear", tree_label = name)
```

![](README_files/figure-markdown_github/unnamed-chunk-23-1.png)

This plot makes it apparent that most taxa were amplified, but not all. The data can also be subset to better see what did not get amplified:

``` r
set.seed(1) 
pcr %>%
  filter_taxa(count_amplified < n_obs) %>% 
  plot(node_size = n_obs, node_label = name, node_color = prop_amplified,
       node_color_range =  c("red", "orange", "yellow", "green", "cyan"),
       initial_layout = "reingold-tilford", layout = "davidson-harel",
       node_color_interval = c(0, 1), node_color_trans = "linear",
       node_label_max = 500, tree_label = name)
```

![](README_files/figure-markdown_github/unnamed-chunk-25-1.png)

### Differential Metadiversity Plots

We can use what we call **Differential Metadiversity Plots** to compare the values of treatments such as:

-   the relative abundance of taxa in two communities
-   the coverages of different primer pairs

Here, we compare the effectiveness 515F/806R to another primer pair 357F/519F, by plotting the difference in proportions amplified by each. First, the same sequences are amplified with 357F/519F and results for the two primer pairs combined:

``` r
pcr_2 <- primersearch(sampled,
                      forward = c("357F" = "CTCCTACGGGAGGCAGCAG"), 
                      reverse = c("519F" = "GWATTACCGCGGCKGCTG"), 
                      mismatch = 10)
pcr <- mutate_taxa(pcr, 
                   count_amplified_2 = taxon_data(pcr_2, col_subset = "count_amplified", drop = TRUE),
                   prop_diff = prop_amplified - taxon_data(pcr_2, col_subset = "prop_amplified", drop = TRUE))
```

Then, taxa that are not amplified by both pairs can be subset and the difference in amplification plotted. In the plot below, green corresponds to taxa amplified by 515F/806R but not 357F/519F and brown is the opposite:

``` r
set.seed(2)
pcr %>%
  filter_taxa(abs(prop_diff) > 0.1, supertaxa = TRUE) %>%
  plot(node_size = n_obs,
       node_label = ifelse(abs(prop_diff) > 0.3, name, NA),
       node_color = prop_diff,
       node_color_range = diverging_palette(),
       node_color_interval = c(-1, 1),
       node_color_trans = "linear",
       node_label_max = 500,
       tree_label = name,
       node_color_axis_label = "Difference in proportion amplified",
       node_size_axis_label = "Sequence count",
       initial_layout = "reingold-tilford", layout = "davidson-harel",
       title = "Comparison of two universal primer pairs using in silico PCR",
       title_size = 0.03)
```

![](README_files/figure-markdown_github/unnamed-chunk-28-1.png)

### Plans for future development

MetacodeR is under active development and many new features are planned. Some improvements that are being worked on include:

-   Increases in function speed
-   Plotting functions for pairwise comparison of treatments
-   Barcoding gap analysis and associated plotting functions
-   A function to aid in retrieving appropriate sequence data from NCBI for *in silico* PCR from whole genome sequences.

To see the details of what is being worked on, check out the [issues](https://github.com/grunwaldlab/metacoder/issues) tab of the MetacodeR [Github site](https://github.com/grunwaldlab).

### Error reports, comments, and contributions

We would like to hear about users' thoughts on the package and any errors they run into. Please report bugs and comments on the [issues](https://github.com/grunwaldlab/metacoder/issues) tab of the MetacodeR [Github site](https://github.com/grunwaldlab). We also welcome contributions via a Github [pull request](https://help.github.com/articles/using-pull-requests/).

### Aknowledgements

We thank Tom Sharpton for sharing his metagenomics expertise and advising us. MetacodeR's major dependencies are taxize, igraph, and ggplot2.
