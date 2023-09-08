writeLines(
    jsonlite::prettify(jsonlite::toJSON(jsonlite::read_json(here::here("data-raw/single.json"), TRUE))),
    here::here("data-raw/single.json")
)
rio_formats <- rio::import(here::here("data-raw", "single.json"))
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
