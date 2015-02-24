.guess <- function(filename) {
    if (!is.character(filename)) {
        stop("'filename' is not a string")
    }
    guess_format <- file_ext(filename)
    if(filename == "clipboard") {
        return("clipboard")
    } else if (is.na(guess_format)) {
        stop("Unknown file format")
    } else {
        return(guess_format)
    }
}
