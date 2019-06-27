context("fst imports/exports")
require("datasets")

test_that("Export to fst", {
    skip_if_not_installed(pkg="fst")
    expect_true(export(iris, "iris.fst") %in% dir())
})

test_that("Import from fst", {
    skip_if_not_installed(pkg="fst")
    expect_true(is.data.frame(import("iris.fst")))
})
unlink("iris.fst")
