#' Rescale numeric vector to have specified minimum and maximum.
#' 
#' Rescale numeric vector to have specified minimum and maximum, but allow for hard boundries.
#' Light wrapper for scales::rescale
#' 
#' @param x values to rescale
#' @param to range to scale to
#' @param from range of values the x could have been
#' @param hard_bounds If \code{TRUE}, all values will be forced into the range of \code{to}.
#' 
#' @keywords internal
rescale <- function (x, to = c(0, 1), from = range(x, na.rm = TRUE, finite = TRUE), hard_bounds = TRUE) 
{
  result <- scales::rescale(x, to, from)
  if (hard_bounds) {
    result[result > max(to)] <- max(to)
    result[result < min(to)] <- min(to)
  }
  return(result)
}



#' Covert numbers to colors
#' 
#' Convert numbers to colors.
#' If colors are already supplied, return the input
#' 
#' @param values (\code{numeric}) The numbers to represent as colors
#' @param color_series (\code{character}) Hex values or a character in \code{colors}
#' @param no_color_in_palette (\code{numeric} of length 1) The number of distinct colors to use.
#' @param interval (\code{numeric} of length 2) The range \code{values} could have taken.
#' 
#' 
#' @return \code{character} Hex color codes. 
#' 
#' @keywords internal
apply_color_scale <- function(values, color_series, interval = NULL, no_color_in_palette = 1000) {
  if (is.numeric(values)) { ## Not factors, characters, or hex codes
    palette <- grDevices::colorRampPalette(color_series)(no_color_in_palette)
    if (is.null(interval)) {
      interval <- range(values, na.rm = TRUE, finite = TRUE)
    }
    color_index <- as.integer(rescale(values, to = c(1, no_color_in_palette), from = interval))
    return(palette[color_index])
  } else {
    return(values)
  }
}



#' The defualt quantative color palette
#' 
#' Returns the default color palette for quantative data.
#' 
#' @return \code{character} of hex color codes
#' 
#' @examples
#' quantative_palette()
#' 
#' @export
quantative_palette <- function() {
  return(c("grey", "#018571", "#80cdc1", "#dfc27d", "#a6611a"))
}


#' The defualt qualitative color palette
#' 
#' Returns the default color palette for qualitative data
#' 
#' @return \code{character} of hex color codes
#' 
#' @examples
#' qualitative_palette()
#' 
#' @export
qualitative_palette <- function() {
  return(c(RColorBrewer::brewer.pal(9, "Set1"), RColorBrewer::brewer.pal(9, "Pastel1")))
}

#' The defualt diverging color palette
#' 
#' Returns the default color palette for diverging data
#' 
#' @return \code{character} of hex color codes
#' 
#' @examples
#' diverging_palette()
#' 
#' @export
diverging_palette <- function() {
  return(c("#a6611a", "#DDDDDD", "#018571"))
}
