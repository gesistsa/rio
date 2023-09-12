context("TSV imports/exports")
require("datasets")

test_that("Export to TSV", {
    expect_true(export(iris, "iris.tsv") %in% dir())
})

test_that("Import from TSV", {
    expect_true(is.data.frame(import("iris.tsv")))
})

test_that("fread is deprecated", {
    lifecycle::expect_deprecated(import("iris.tsv", fread = TRUE))
    lifecycle::expect_deprecated(import("iris.tsv", fread = FALSE))
})

unlink("iris.tsv")
