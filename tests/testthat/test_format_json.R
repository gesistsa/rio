context("JSON imports/exports")
require("datasets")

test_that("Export to JSON", {
    expect_true(export(iris, "iris.json") %in% dir())
})

test_that("Import from JSON", {
    expect_true(is.data.frame(import("iris.json")))
})

unlink("iris.json")
