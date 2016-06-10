context("SPSS (.sav) imports/exports")
require("datasets")

test_that("Export to SPSS (.sav)", {
    expect_true(export(iris, "iris.sav") %in% dir())
})

#test_that("Import from SPSS (.sav; read.spss)", {
#    expect_true(is.data.frame(import("iris.sav", haven = FALSE)))
#})

test_that("Import from SPSS (.sav; read_sav)", {
    expect_true(d <- is.data.frame(import("iris.sav", haven = TRUE)))
    expect_true(!"labelled" %in% unlist(lapply(d, class)))
    rm(d)
})

unlink("iris.sav")
