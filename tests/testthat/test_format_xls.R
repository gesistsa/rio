context("Excel (xlsx) imports/exports")
require("datasets")

test_that("Export to Excel (.xlsx)", {
    expect_true(export(iris, "iris.xlsx") %in% dir())
})

test_that("Expert to Excel (.xlsx) a list", {
    tempxlsx <- tempfile(fileext = ".xlsx")
    export(list(
    mtcars3 = mtcars[1:10, ],
    mtcars2 = mtcars[11:20, ],
    mtcars1 = mtcars[21:32, ]
), tempxlsx)
    expect_equal(readxl::excel_sheets(tempxlsx), c("mtcars3", "mtcars2", "mtcars1"))
})

test_that("readxl is deprecated", {
    lifecycle::expect_deprecated(import("iris.xlsx", readxl = TRUE))
    lifecycle::expect_deprecated(import("iris.xlsx", readxl = FALSE))
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
