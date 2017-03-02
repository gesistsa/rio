context("fst imports/exports")
require("datasets")

if (requireNamespace("fst")) {
    test_that("Export to fst", {
        expect_true(export(iris, "iris.fst") %in% dir())
    })

    test_that("Import from fst", {
        expect_true(is.data.frame(import("iris.fst")))
    })
    unlink("iris.fst")
}
