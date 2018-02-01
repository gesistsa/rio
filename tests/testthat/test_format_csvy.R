context("CSVY imports/exports")
require("datasets")

test_that("Export to CSVY", {
    suppressWarnings(expect_true(export(iris, "iris.csvy") %in% dir()))
    unlink("iris.csvy")
})

test_that("Import from CSVY", {
    suppressWarnings(d <- import(system.file("examples", "example.csvy", package = "csvy")))
    expect_true(inherits(d, "data.frame"))
    
    suppressWarnings(d2 <- import(system.file("examples", "example2.csvy", package = "csvy")))
    expect_true(all(c("title", "units", "source") %in% names(attributes(d2))))
    
    suppressWarnings(d3 <- import(system.file("examples", "example3.csvy", package = "csvy")))
    expect_true(identical(dim(d3), c(2L, 3L)))
})
