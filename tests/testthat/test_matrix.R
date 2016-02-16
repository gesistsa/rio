context("Matrix imports/exports")
require("datasets")

test_that("Export matrix to CSV", {
    expect_true(export(warpbreaks, "temp1.csv") %in% dir())
    expect_true(export(as.matrix(warpbreaks), "temp2.csv") %in% dir())
})

test_that("Import from matrix export", {
    expect_true(identical(import("temp1.csv", colClasses = rep("character", 3)), 
                          import("temp2.csv", colClasses = rep("character", 3))))
})

unlink("temp1.csv")
unlink("temp2.csv")
