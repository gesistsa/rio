context("TSV imports/exports")
require("datasets")

test_that("Export to TSV", {
    expect_true(export(iris, "iris.tsv") %in% dir())
})

test_that("Import from TSV", {
    expect_true(is.data.frame(import("iris.tsv")))
})

unlink("iris.tsv")
