context("Parquet imports/exports")
require("datasets")

test_that("Export to and import from parquet", {
    skip_if_not_installed("arrow")
    expect_true(export(iris, "iris.parquet") %in% dir())
    expect_true(is.data.frame(import("iris.parquet")))
    unlink("iris.parquet")
})
