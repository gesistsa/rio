context(".csv.gz imports/exports")
require("datasets")

test_that("Export to csv.gz", {
    expect_true(export(iris, "iris.csv.gz") %in% dir())
})

test_that("Import from csv.gz", {
    expect_true(inherits(import("iris.csv.gz"), "data.frame"))
})

unlink("iris.csv.gz")
