standardize_attributes <- function(dat) {
    out <- dat
    a <- attributes(out)
    if ("variable.labels" %in% names(a)) {
        names(a)[names(a) == "variable.labels"] <- "var.labels"
        a$var.labels <- unname(a$var.labels)
    }
    # cleanup import
    attr(out, "var.labels") <- NULL      # Stata
    attr(out, "variable.labels") <- NULL # SPSS
    attr(out, "formats") <- NULL
    attr(out, "types") <- NULL
    attr(out, "label.table") <- NULL
    for (i in 1:length(out)) {
        if ("value.labels" %in% names(attributes(out[[i]]))) {
            attr(out[[i]], "labels") <- attr(out[[i]], "value.labels")
            attr(out[[i]], "value.labels") <- NULL
        }
        if (inherits(out[[i]], "labelled")) {
            out[[i]] <- unclass(out[[i]])
        }
        if ("var.labels" %in% names(a)) {
            attr(out[[i]], "label") <- a$var.labels[i]
        }
        if ("formats" %in% names(a)) {
            attr(out[[i]], "format") <- a$formats[i]
        }
        if ("types" %in% names(a)) {
            attr(out[[i]], "type") <- a$types[i]
        }
        if ("val.labels" %in% names(a) && (a$val.labels[i] != "")) {
            attr(out[[i]], "labels") <- a$label.table[[a$val.labels[i]]]
        }
    }
    out
}

#' @title Convert data.frame variables to factors using variable attributes
#' @description This function converts columns with labels for every value to factors
#' @details \code{\link{import}} attempts to standardize the return value from the various import functions to the extent possible, thus providing a uniform data structure regardless of what import package or function is used. It achieves this by storing any optional variable-related attributes at the variable level. This has the advantage of not losing meta-data during import, but often results in categorical data being imported as labeled numbers rather than characters or factors. This function can be used to guess which columns contain categorical data and convert them to factors or character vectors.
#' @param x A data.frame.
#' @param to Either 'factor' or 'character'.
#' @param exclude A character vector of column names to excluded from conversion.
#' @return \code{x}, usually with some columns converted to factors or character vectors.
#' @examples
#' e <- import("http://www.stata-press.com/data/r14/labelbook1.dta")
#' e <- e[, c(20:21, 936, 997)]
#' str(e)
#' g <- rio:::heuristic_factor(e)
#' str(g)
#' h <- rio:::heuristic_factor(e, to = "character", exclude = "rk21")
#' str(h)
#' @seealso \code{\link{cleanup_attrs}}, \code{\link{gather_attrs}}
#' @keywords internal
heuristic_factor <- function(x, to = c("character", "factor"), exclude = "", quiet = FALSE) {
  if (!inherits(x, "data.frame")) {
    stop("'x' is not a data.frame")
  }
  if(!inherits(to, "character")) {
    stop("'to' is not character vector")
  }
  if(!any(to %in% c("factor", "character"))) {
    stop("'to' must be either 'factor' or 'character'")
  }
  if(!inherits(exclude, "character")) {
    stop("'exclude' is not a character vector")
  }
  if(exclude != "" && !any(grepl(exclude, names(x)))) {
    warning("No column names matching the 'exclude' argument are present")
  }
  discrete <- sapply(x, function(y) {
    length(unique(attr(y, "labels"))) >= length(stats::na.omit(unique(y)))
  })
  excluded <- names(x) %in% exclude
  if(length(excluded) > 0) discrete[excluded] <- FALSE
  if(sum(discrete) >0) {
    x[discrete] <- lapply(x[discrete], function(y) {
      vlabel <- attr(y, "label")
      labels <- attr(y, "labels")
      y <- factor(y, levels = labels)
      levels(y) <- names(labels)
      if(to[1L] == "character") y <- as.character(y)
      if(length(vlabel) > 0) attr(y, "label") <- vlabel
      return(y)
    })
    if(!quiet) {
      message("Variable(s) ",
              paste0(names(x)[discrete], collape = ", "),
              " converted to ",
              to[1L])
    }
  }
  return(x)
}


#' @title Guess missing values in data.frame variables using variable attributes
#' @description This function guesses which values are missing and converts them to NA
#' @details \code{\link{import}} attempts to standardize the return value from the various import functions to the extent possible, thus providing a uniform data structure regardless of what import package or function is used. It achieves this by storing any optional variable-related attributes at the variable level. This has the advantage of not losing meta-data during import, but often requires post-processing to identify missing values and convert them to NA. This function attempts to automate this process by guessing which values are missing based on the column attributes. Specifically, labeled values in columns with lables attributes for which less than \code{percent} of the values are labeled are converted to NA.
#' @param x A data.frame.
#' @param exclude A character vector of column names to excluded from conversion.
#' @return \code{x}, usually with some values replaced with NA.
#' @examples
#' e <- import("http://www.stata-press.com/data/r14/labelbook1.dta")
#' e <- e[, c(20:21, 936, 997)]
#' str(e)
#' g <- rio:::heuristic_na(e)
#' str(g)
#' @seealso \code{\link{cleanup_attrs}}, \code{\link{gather_attrs}}
#' @keywords internal
heuristic_na <- function(x, percent = 40, exclude = "", quiet = FALSE) {
  if (!inherits(x, "data.frame")) {
    stop("'x' is not a data.frame")
  }
  if(!inherits(exclude, "character")) {
    stop("'exclude' is not a character vector")
  }
  if(exclude != "" && !any(grepl(exclude, names(x)))) {
    warning("No column names matching the 'exclude' argument are present")
  }
  na <- sapply(x, function(y) {
    lb <- attr(y, "labels")
    if (is.null(lb)) return(FALSE)
    length(lb)/length(stats::na.omit(unique(y))) <= percent/100
  })
  excluded <- names(x) %in% exclude
  if(length(excluded) > 0) na[excluded] <- FALSE
  if(sum(na) > 0) {
    x[na] <- lapply(x[na], function(y) {
      labeled <- y %in% attr(y, "labels")
      attr(y, "labels") <- NULL
      y[labeled] <- NA
      return(y)
    })
    if(!quiet) {
      message("Missing values detected and converted in variable(s) ",
              paste0(names(x)[na], collape = ", "))
    }
  }
  return(x)
}
