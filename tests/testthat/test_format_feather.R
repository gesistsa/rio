context("feather imports/exports")
require("datasets")

test_that("Export to feather", {
    expect_true(export(iris, "iris.feather") %in% dir())
})

test_that("Import from feather", {
    expect_true(is.data.frame(import("iris.feather")))
})

test_that("... correctly passed, #318", {
    ## actually feather::write_feather has only two arguments (as of 2023-09-01)
    ## it is more for possible future expansion
    expect_error(export(mtcars, "mtcars.feather", hello = 42))
})

unlink("iris.feather")
