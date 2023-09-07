writeLines(
    jsonlite::prettify(jsonlite::toJSON(jsonlite::read_json(here::here("data-raw/single.json"), TRUE))),
    here::here("data-raw/single.json")
)
rio_formats <- rio::import(here::here("data-raw", "single.json"))
usethis::use_data(rio_formats, overwrite = TRUE, internal = TRUE)
