set_class <- function(x, class = NULL) {
    if (is.null(class)) {
        return(structure(x, class = "data.frame"))
    }
    pkg <- switch(class, 
                  "tbl_df" = "dplyr", 
                  "data.table" = "data.table",
                  NA)
    if (!is.na(pkg)) {
        if(!pkg %in% loadedNamespaces()) {
            if(!pkg %in% row.names(installed.packages())) {
                warning(sprintf("Package '%s' has not been installed.", pkg))
            } else {
                warning(sprintf("Package '%s' has not been loaded.", pkg))
            }
        }
    }
    return(structure(x, class = c(class[!class %in% c("data.frame", class(x))], "data.frame")))
}
