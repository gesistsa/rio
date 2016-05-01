context("HTML imports/exports")
require("datasets")

test_that("Export to HTML", {
    expect_true(export(iris, "iris.html") %in% dir())
})

test_that("Import from HTML", {
    expect_true(is.data.frame(import("iris.html")))
})

unlink("iris.html")
