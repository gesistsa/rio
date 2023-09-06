context("qs import/export")
require("datasets")

test_that("Export to qs", {
    skip_if_not_installed(pkg = "qs")
    expect_true(export(iris, "iris.qs") %in% dir())
})

test_that("Import from qs", {
    skip_if_not_installed(pkg = "qs")
    expect_true(is.data.frame(import("iris.qs")))
})
unlink("iris.qs")
