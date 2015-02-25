get_type <- function(fmt) {
    type_list <- list(
        dta = "dta",
        stata = "dta",
        spss = "sav",
        excel = "xlsx"
    )
    type <- type_list[[tolower(fmt)]]
    if(is.null(type)) {
        stop("Unrecognized file format")
    } else {
        return(type)
    }
}

get_ext <- function(file) {
    if (!is.character(file)) {
        stop("'file' is not a string")
    }
    if(!grepl("^http.*://", file)) {
        fmt <- file_ext(file)
    }
    else if(grepl("^http.*://", file)) {
        fmt <- gsub("(.*\\/)([^.]+)\\.", "", file)
    }
    if(file == "clipboard") {
        return("clipboard")
    } else if (fmt == "") {
        stop("'file' has no extension")
    } else {
        return(tolower(fmt))
    }
}
