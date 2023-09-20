writeLines(
    jsonlite::prettify(jsonlite::toJSON(jsonlite::read_json(here::here("data-raw/single.json"), TRUE))),
    here::here("data-raw/single.json")
)
rio_formats <- rio::import(here::here("data-raw", "single.json"))

all_functions <- unlist(rio_formats[rio_formats$type == "suggest", c("import_function", "export_function")], use.names = FALSE)
suggestions <- unique(stats::na.omit(stringi::stri_extract_first(all_functions, regex = "[a-zA-Z0-9\\.]+")))
attr(rio_formats, "suggested_packages") <- c(suggestions, "stringi")
usethis::use_data(rio_formats, overwrite = TRUE, internal = TRUE)

## #351

## old_data <- jsonlite::read_json(here::here("data-raw/single.json"), TRUE)

## new_data <- old_data
## colnames(new_data)[2] <- "format"

## writeLines(jsonlite::prettify(jsonlite::toJSON(new_data)), here::here("data-raw/single.json"))
## rio_formats <- rio::import(here::here("data-raw", "single.json"))
## usethis::use_data(rio_formats, overwrite = TRUE, internal = TRUE)

## #351 remove ext
## old_data <- jsonlite::read_json(here::here("data-raw/single.json"), TRUE)
## new_data <- old_data[, -3]
## writeLines(jsonlite::prettify(jsonlite::toJSON(new_data)), here::here("data-raw/single.json"))
## rio_formats <- rio::import(here::here("data-raw", "single.json"))
## usethis::use_data(rio_formats, overwrite = TRUE, internal = TRUE)
