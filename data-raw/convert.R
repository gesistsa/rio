
writeLines(jsonlite::read_json("data-raw/single.json", TRUE))
rio_formats <- rio::import(here::here("data-raw", "single.json"))

usethis::use_data(rio_formats, overwrite = TRUE, internal = TRUE)

require(data.table)
rf <- data.table(rio_formats)[type %in% c("import", "suggest", "archive"), !"ext"]
short_rf <- rf[, paste(input, collapse = " / "), by = format_name]
type_rf <- unique(rf[,c("format_name", "type", "import_function", "export_function", "note")])

feature_table <- short_rf[type_rf, on = .(format_name)]

colnames(feature_table)[2] <- "signature"

setorder(feature_table, "type", "format_name")
