context("PSV imports/exports")
require("datasets")

test_that("Export to PSV", {
    expect_true(export(iris, "iris.psv") %in% dir())
})

test_that("Import from PSV", {
    expect_true(is.data.frame(import("iris.psv")))
})

test_that("fread is deprecated", {
    lifecycle::expect_deprecated(import("iris.psv", fread = TRUE))
    lifecycle::expect_deprecated(import("iris.psv", fread = FALSE))
})


unlink("iris.psv")
