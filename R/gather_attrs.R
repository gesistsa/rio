#' @title Gather attributes from data.frame variables
#' @description This function moves variable-level attributes to the data.frame level
#' @details \code{\link{import}} attempts to standardize the return value from the various import functions to the extent possible, thus providing a uniform data structure regardless of what import package or function is used. It achieves this by storing any optional variable-related attributes at the variable level (i.e., an attribute for \code{mtcars$mpg} is stored in \code{attributes(mtcars$mpg)} rather than \code{attributes(mtcars)}). \code{gather_attrs} moves these to the data.frame-level (i.e., in \code{attributes(mtcars)}).
#' @param x A data.frame.
#' @return \code{x}, with variable-level attributes stored at the data.frame level.
#' @examples
#' e <- import("http://www.stata-press.com/data/r13/auto.dta")
#' str(e)
#' g <- gather_attrs(e)
#' str(attributes(e))
#' str(g)
#' @seealso \code{\link{import}}
#' @export
gather_attrs <- function(x) {
    if (!inherits(x, "data.frame")) {
        stop("'x' is not a data.frame")
    }
    dfattrs <- attributes(x)
    varattrs <- rep(list(list()), length(x))
    for (i in seq_along(x)) {
        a <- attributes(x[[i]])
        varattrs[[i]] <- a[!names(a) %in% c("levels", "class")]
        attributes(x[[i]]) <- a[names(a) %in% c("levels", "class")]
    }
    if (any(sapply(varattrs, length))) {
        attrnames <- sort(unique(unlist(lapply(varattrs, names))))
        outattrs <- setNames(lapply(attrnames, function(z) {
            setNames(lapply(varattrs, `[[`, z), names(x))
        }), attrnames)
        attributes(x) <- c(dfattrs, outattrs)
    }
    x
}


#' @title Cleanup a data.frame using attribute heuristics
#' @description This function by default converts columns with labels for every value to factors and labeled values in sparsely labeled columns with NA; it optionally moves variable-level attributes to the data.frame level
#' @details \code{\link{import}} attempts to standardize the return value from the various import functions to the extent possible, thus providing a uniform data structure regardless of what import package or function is used. It achieves this by storing any optional variable-related attributes at the variable level. This has the advantage of not losing meta-data during import, but often results in categorical data being imported as labeled numbers rather than characters or factors.  This function can be used to guess which columns contain categorical data and convert them to factors or character vectors.
#' @param x A data.frame.
#' @param convert_factors A length-one logical. Should columns with labels for every value be converted to factors? Default is TRUE.
#' @param convert_na A length-one logical. Should labeled values in colums with sparse labels be converted to NA? Default is FALSE.
#' @param gather_attrs A length-one logical. Should variable-level meta-data be move to data.frame attributes? Default is FALSE
#' @param exclude exclude A character vector of column names to excluded from conversion. Default is "".
#' @param to Either 'character' (default) or 'factor'; type to convert categorical columns to.
#' @param percent A length-one integer used as the cutoff when identifying sparsely labeled columns. Default is 30.
#' @param quiet A length-one logical. Should information about modified colums be printed? Default is FALSE.
#' @return \code{x}, usually with some columns converted to factors or character vectors, and optionally with some values replaced with NA and/or variable-level attributes moved to data.frame attributes.
#' @examples
#' # Since Stata doesn't handle factors well, categorical data is often stored
#' # as labeled numbers, as in this data set
#' e <- import("http://www.stata-press.com/data/r14/labelbook1.dta")
#' e <- e[, c(20:21, 936, 997)]
#' str(e)
#' summary(e)
#' # Use variable attributes to guess wich colums are categorical and convert them
#' g <- cleanup_attrs(e)
#' str(g)
#' summary(g)
#' # Sometimes the heuristic is too aggressive; colums can be explicitly excluded
#' h <- cleanup_attrs(e, exclude = "rk21", to = "factor")
#' str(h)
#' summary(h)
#' # Optionally detect likely NA values and/or move column attributes to data.frame attributes
#' i <- cleanup_attrs(e, convert_na = TRUE, gather_attrs = TRUE, to = "factor")
#' str(i)
#' summary(i)
#' @seealso \code{\link{gather_attrs}}
#' @export
cleanup_attrs <- function(x,
                          convert_factors = TRUE,
                          convert_na = FALSE,
                          gather_attrs = FALSE,
                          exclude = "",
                          to = c("character", "factor"),
                          percent = 40,
                          quiet = FALSE) {
  if (!inherits(x, "data.frame")) {
    stop("'x' is not a data.frame")
  }
  if(!inherits(convert_factors, "logical") || length(convert_factors) != 1) {
    stop("'convert_factors' is not a logical of length one")
  }
  if(!inherits(convert_na, "logical") || length(convert_na) != 1) {
    stop("'convert_na' is not a logical of length one")
  }
  if(!inherits(gather_attrs, "logical") || length(gather_attrs) != 1) {
    stop("'gather_attrs' is not a logical of length one")
  }
  if(convert_factors) {
    x <- heuristic_factor(x,
                          to = to,
                          exclude = exclude,
                          quiet = quiet)
  }
  if(convert_na) {
    x <- heuristic_na(x,
                      percent = percent,
                      exclude = exclude,
                      quiet = quiet)
  }
  if(gather_attrs) x <- gather_attrs(x)
  return(x)
}
