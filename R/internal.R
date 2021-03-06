#' get_edge_parents
#' 
#' @keywords internal
get_edge_parents <-function(graph) {
  igraph::get.edges(graph, 1:igraph::ecount(graph))[,1]
}


#' get_edge_children
#' 
#' @keywords internal
get_edge_children <- function(graph) {
  igraph::get.edges(graph, 1:igraph::ecount(graph))[,2]
}


#' get_node_children
#' 
#' @keywords internal
get_node_children <- function(graph, node) {
  which(igraph::shortest.paths(graph, igraph::V(graph)[node], mode="out") != Inf)
}


#' delete_vetices_and_children
#' 
#' @keywords internal
delete_vetices_and_children <- function(graph, nodes) {
  nodes <- unlist(sapply(nodes, function(x) get_node_children(graph, x)))
  graph <- igraph::delete.vertices(graph, nodes)
  return(graph)
}


#' add_alpha
#' 
#' @keywords internal
add_alpha <- function(col, alpha = 1){
  apply(sapply(col, grDevices::col2rgb) / 255, 2,
        function(x) grDevices::rgb(x[1], x[2], x[3], alpha = alpha))
}


#' get indexes of a unique set of the input
#' 
#' @keywords internal
unique_mapping <- function(input) {
  unique_input <- unique(input)
  vapply(input, function(x) {if (is.na(x)) which(is.na(unique_input)) else which(x == unique_input)}, numeric(1))
}


#' Run a function on unique values of a iterable 
#' 
#' @param input What to pass to \code{func}
#' @param func (\code{function})
#' @param ... passend to \code{func}
#' 
#' @keywords internal
map_unique <- function(input, func, ...) {
  input_class <- class(input)
  unique_input <- unique(input)
  class(unique_input) <- input_class
  func(unique_input, ...)[unique_mapping(input)]
}


#' Converts DNAbin to a named character vector
#' 
#' Converts an object of class DNAbin (as produced by ape) to a named character vector.
#' 
#' @param dna_bin (\code{DNAbin} of length 1) the input.
#' 
#' @keywords internal
DNAbin_to_char <- function(dna_bin) {
  vapply(as.character(dna_bin), paste, character(1), collapse="")
}