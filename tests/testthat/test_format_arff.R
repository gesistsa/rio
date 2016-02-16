context("Weka (.arff) imports/exports")
require("datasets")

test_that("Export to Weka", {
    expect_true(export(iris, "iris.arff") %in% dir())
})

test_that("Import from Weka", {
    expect_true(is.data.frame(import("iris.arff")))
})

unlink("iris.arff")
