context("SPSS (.sav) imports/exports")
require("datasets")

test_that("Export to SPSS (.sav)", {
    expect_true(export(iris, "iris.sav") %in% dir())
})

test_that("Import from SPSS (.sav)", {
    expect_true(is.data.frame(import("iris.sav")))
})

unlink("iris.sav")

#context("SPSS (.por) imports")
#test_that("Import from SPSS (.por)", {})
