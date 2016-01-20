convert_google_url <- function(url, export_as = "csv") {
    ## convert a google sheets url to google csv export URL
    ## extract the doc-id and append /export?format = csv to it. (default)
    google_key <- regmatches(url, regexpr("[[:alnum:]_-]{30,}", url))
    if (grepl('gid=[[:digit:]]+', url)) {
        gidpart <- paste0(regmatches(url, regexpr("gid=[[:digit:]]+", url)))
    } else {
        gidpart <- "gid=0"
    }
    return(paste0('https://docs.google.com/spreadsheets/d/', google_key, '/export?', gidpart, '&format=', export_as))
}
