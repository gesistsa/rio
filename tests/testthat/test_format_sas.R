context("SAS imports/exports")
require("datasets")

#test_that("Import from SAS (.sas7bdat)", {})
#test_that("Import from SAS (.xpt)", {})

test_that("Export SAS (.sas7bdat)", {
    expect_true(export(mtcars, "mtcars.sas7bdat") %in% dir())
})

unlink("mtcars.sas7bdat")
