#' @title Reconcile an argument list to any function signature.
#' 
#' @description Adapt an argument list to a function excluding arguments that 
#'              will not be recognized by it, redundant arguments, and un-named
#'              arguments. 
#'
#' @param fun      A function to which an argument list needs to be adapted. Use
#'                 the unquoted name of the function. If it's in a different 
#'                 package then the fully qualified unquoted name (e.g. 
#'                 \code{utils::read.table})
#' @param ...      An arbitrary list of named arguments (unnamed ones will be 
#'                 ignored). Arguments in \code{.args} are overridden by
#'                 arguments of the same name (if any) in \code{...}
#' @param .args    A list or \code{alist} of named arguments, to be merged 
#'                 with \code{...}. Arguments in \code{.args} are overridden by
#'                 arguments of the same name (if any) in \code{...}
#' @param .docall  If set to \code{TRUE} will not only clean up the arguments 
#'                 but also execute \code{fun} with those arguments 
#'                 (\code{FALSE} by default) and return the results
#' @param .include Whitelist. If not empty, only arguments named here will be 
#'                 permitted, and only if they satisfy the conditions implied by
#'                 the other arguments. Evaluated before \code{.remap}.
#' @param .exclude Blacklist. If not empty, arguments named here will be removed 
#'                 even if they satisfy the conditions implied by the other 
#'                 arguments. Evaluated before \code{.remap}.
#' @param .remap   An optional named character vector or named list of character 
#'                 values for standardizing arguments that play the same role 
#'                 but have different names in different functions. Evaluated 
#'                 after \code{.exclude} and \code{.include}.
#' @param .warn    Whether to issue a warning message (default) when invalid 
#'                 arguments need to be discarded.
#' @param .error   If specified, should be the object to return in the event of
#'                 error. This object will have the error as its 
#'                 \code{error} attribute. If not specified an ordinary error is
#'                 thrown with an added hint on the documentation to read for 
#'                 troubleshooting. Ignored if \code{.docall} is \code{FALSE}.
#'                 The point of doing this is fault-tolerance-- if this function
#'                 is part of a lengthy process where you want to document an 
#'                 error but keep going, you can set \code{.error} to some 
#'                 object of a compatible type. That object will be returned in 
#'                 the event of error and will have as its \code{"error"} 
#'                 attribute the error object.
#' @param .finish  A function to run on the result before returning it. Ignored 
#'                 if \code{.docall} is \code{FALSE}.
#'
#' @return Either a named list or the result of calling \code{fun} with the 
#'         supplied arguments
#'
arg_reconcile <- function(fun, ..., .args = alist(), .docall = FALSE, 
                          .include = c(), .exclude= c(), .remap = list(), 
                          .warn = TRUE, .error = "default", .finish = identity) {
  # capture the formal arguments of the target function
  frmls <- formals(fun)
  # both freeform and an explicit list
  args <- match.call(expand.dots = FALSE)[["..."]]
  if (isTRUE(.docall)) {
    for (ii in names(args)) {
      try(args[[ii]] <- eval(args[[ii]], parent.frame()))
    }
  }
  # get rid of duplicate arguments, with freeform arguments 
  dupes <- names(args)[duplicated(names(args))]
  for (ii in dupes) {
    args[which(names(args) == ii)[-1]] <- NULL
  }
  # Merge ... with .args
  args <- c(args, .args)
  # Apply whitelist and blacklist. This step also removes duplicates _between_
  # the freeform (...) and pre-specified (.args) arguments, with ... versions
  # taking precedence over the .args versions. This is a consequence of the 
  # intersect() and setdiff() operations and works even if there is no blacklist
  # nor whitelist
  if (!missing(.include)) {
    args <- args[intersect(names(args), .include)]
  }
  args <- args[setdiff(names(args), .exclude)]
  # if any remappings of one argument to another are specified, perform them
  for (ii in names(.remap)) {
    if (!.remap[[ii]] %in% names(args) && ii %in% names(args)) {
      args[[.remap[[ii]] ]] <- args[[ii]]
    }
  }
  # remove any unnamed arguments
  args[names(args) == ""] <- NULL
  # if the target function doesn't have "..." as an argument, check to make sure
  # only recognized arguments get passed, optionally with a warning
  if (!"..." %in% names(frmls)) {
    unused <- setdiff(names(args), names(frmls))
    if (length(unused)>0){
      if (isTRUE(.warn)) {
        warning("The following arguments were ignored for ", 
                deparse(substitute(fun)), ":\n", paste(unused, collapse = ", "))
      }
      args <- args[intersect(names(args), names(frmls))]
    }
  }
  # the final, cleaned-up arguments either get returned as a list or used on the 
  # function, depending on how .docall is set
  if (!isTRUE(.docall)) {
    return(args)
  } else {
    # run the function and return the result case
    oo <- try(do.call(fun, args), silent = TRUE)
    if (!inherits(oo, "try-error")) {
      return(.finish(oo))
    } else {
      # construct an informative error... eventually there will be more 
      # detailed info here
      errorhint <- paste('\nThis error was generated by: ', 
                         deparse(match.call()$fun), 
                         '\nWith the following arguments:\n', 
                         gsub('^list\\(|\\)$', '', 
                              paste(deparse(args, control=c('delayPromises')), 
                                    collapse='\n')))
      if (missing(.error)) {
        stop(attr(oo, "condition")$message, errorhint)
      } else {
        attr(.error, "error") <- oo
        return(.error)
      }
    }
  }
}

