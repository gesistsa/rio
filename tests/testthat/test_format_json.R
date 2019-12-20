context("JSON imports/exports")
require("datasets")

test_that("Export to JSON", {
    skip_if_not_installed("jsonlite")
    expect_true(export(iris, "iris.json") %in% dir())
})

test_that("Import from JSON", {
    skip_if_not_installed("jsonlite")
    expect_true(is.data.frame(import("iris.json")))
})

test_that("Export to JSON (non-data frame)", {
    skip_if_not_installed("jsonlite")
    expect_true(export(list(1:10, letters), "list.json") %in% dir())
    expect_true(inherits(import("list.json"), "list"))
    expect_true(length(import("list.json")) == 2L)
})

unlink("iris.json")
unlink("list.json")
