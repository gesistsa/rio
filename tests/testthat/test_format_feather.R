context("feather imports/exports")
require("datasets")

test_that("Export to feather", {
    expect_true(export(iris, "iris.feather") %in% dir())
})

test_that("Import from feather", {
    expect_true(is.data.frame(import("iris.feather")))
})

unlink("iris.json")
