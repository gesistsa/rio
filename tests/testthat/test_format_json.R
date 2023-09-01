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

test_that("utf-8", {
    content <- c("\"", "\u010d", "\u0161", "\u00c4", "\u5b57", "\u30a2", "\u30a2\u30e0\u30ed")
    x <- data.frame(col = content)
    tempjson <- tempfile(fileext = ".json")
    y <- import(export(x, tempjson))
    testthat::expect_equal(content, y$col)
})

unlink("iris.json")
unlink("list.json")
