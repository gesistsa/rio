context("Parquet imports/exports")
require("datasets")
arrow::install_arrow()

test_that("Export to parquet", {
    skip_if_not_installed("arrow")
    expect_true(export(iris, "iris.parquet") %in% dir())
})

test_that("Import from parquet", {
    skip_if_not_installed("arrow")
    expect_true(is.data.frame(import("iris.parquet")))
})

unlink("iris.parquet")
