context("rmatio imports/exports")
require("datasets")

test_that("Export to matlab", {
    skip_if_not_installed(pkg="rmatio")
    expect_true(export(iris, "iris.matlab") %in% dir())
})

test_that("Import from matlab", {
    skip_if_not_installed(pkg="rmatio")
    expect_true(is.data.frame(import("iris.matlab")))
    expect_true(identical(dim(import("iris.matlab")), dim(iris)))
})
unlink("iris.matlab")
