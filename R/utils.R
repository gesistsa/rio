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
    fmt <- file_ext(file)
    if(file == "clipboard") {
        return("clipboard")
    } else if (fmt == "") {
        stop("'file' has no extension")
    } else {
        return(tolower(fmt))
    }
}
