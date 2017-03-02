context("rmatio imports/exports")
require("datasets")

if (requireNamespace("rmatio")) {
    test_that("Export to matlab", {
        expect_true(export(iris, "iris.matlab") %in% dir())
    })

    test_that("Import from matlab", {
        expect_true(is.data.frame(import("iris.matlab")))
    })
    unlink("iris.matlab")
}
