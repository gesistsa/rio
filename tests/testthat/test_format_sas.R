context("SAS imports/exports")
require("datasets")

#test_that("Import from SAS (.sas7bdat)", {})
test_that("Export SAS (.xpt)", {
    expect_true(export(mtcars, "mtcars.xpt") %in% dir())
})

test_that("Import from SAS (.xpt)", {
    expect_true(inherits(import("mtcars.xpt"), "data.frame"))
})

test_that("Export SAS (.sas7bdat)", {
    expect_true(export(mtcars, "mtcars.sas7bdat") %in% dir())
})

test_that("can use select helpers to pick columns (#248)", {
    expect_named(import("mtcars.sas7bdat", col_select = any_of("mpg")), "mpg")
})

unlink("mtcars.sas7bdat")
unlink("mtcars.xpt")
