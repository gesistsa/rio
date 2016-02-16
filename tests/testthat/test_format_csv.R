context("CSV imports/exports")
require("datasets")

test_that("Export to CSV", {
    expect_true(export(iris, "iris.csv") %in% dir())
    unlink("iris.csv")
})

test_that("Import from CSV", {
    noheadercsv <- import(system.file("examples", "noheader.csv", package = "rio"), header = FALSE)
    expect_that(colnames(noheadercsv)[1], equals("V1"), label = "Header is correctly specified")
})

unlink("iris.csv")
