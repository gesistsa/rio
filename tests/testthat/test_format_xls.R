context("Excel (xlsx) imports/exports")
require("datasets")

test_that("Export to Excel (.xlsx)", {
    expect_true(export(iris, "iris.xlsx") %in% dir())
    expect_true(export(mtcars, "iris.xlsx", which = 2) %in% dir())
})

test_that("Import from Excel (.xlsx)", {
    expect_true(is.data.frame(import("iris.xlsx", readxl = FALSE)))
    expect_true(is.data.frame(import("iris.xlsx", readxl = TRUE)))
    expect_true(is.data.frame(import("iris.xlsx", sheet = 1)))
    expect_true(is.data.frame(import("iris.xlsx", which = 1)))
    expect_true(nrow(import("iris.xlsx", n_max = 42))==42)
    expect_warning(is.data.frame(import("iris.xlsx", nrows = 42)), "nrows",
                   label = "xlsx reads the file and ignores unused arguments with warning")
})

test_that("Import from Excel (.xls)", {
    expect_true(is.data.frame(import("../testdata/iris.xls")))
    expect_true(is.data.frame(import("../testdata/iris.xls", sheet = 1)))
    expect_true(is.data.frame(import("../testdata/iris.xls", which = 1)))
    expect_warning(is.data.frame(import("../testdata/iris.xls", which = 1,
                                        nrows = 42)), "nrows",
                   label="xls reads the file and ignores unused arguments with warning")
})


unlink("iris.xlsx")
