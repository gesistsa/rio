context("Excel imports/exports")
require("datasets")

test_that("Export to Excel (.xlsx)", {
    expect_true(export(iris, "iris.xlsx") %in% dir())
})

test_that("Import from Excel (.xlsx)", {
    expect_true(is.data.frame(import("iris.xlsx", readxl = FALSE)))
    expect_true(is.data.frame(import("iris.xlsx", readxl = TRUE)))
    expect_true(is.data.frame(import("iris.xlsx", sheet = 1)))
    expect_true(is.data.frame(import("iris.xlsx", which = 1)))
})

unlink("iris.xlsx")
