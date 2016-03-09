context("YAML imports/exports")
require("datasets")

test_that("Export to YAML", {
    expect_true(export(iris, "iris.yml") %in% dir())
})

test_that("Import from YAML", {
    expect_true(is.data.frame(import("iris.yml")))
})

unlink("iris.yml")
