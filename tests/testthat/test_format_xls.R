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
    expect_warning(is.data.frame(import("iris.xlsx", nrows = 42)),
                   "The following arguments were ignored when readxl = TRUE:\nnrows",
                   label="xlsx reads the file and ignores unused arguments with warning")
})

test_that("Import from Excel (.xls)", {
    expect_true(is.data.frame(import(system.file('examples','iris.xls',
                                                 package='rio'))))
    expect_true(is.data.frame(import(system.file('examples','iris.xls',
                                                 package='rio'), sheet = 1)))
    expect_true(is.data.frame(import(system.file('examples','iris.xls',
                                                 package='rio'), which = 1)))
    expect_warning(is.data.frame(import(system.file('examples','iris.xls',
                                                 package='rio'), which = 1,
                                        invalid_argument = 42)),
                                 "The following arguments were ignored by read_xls:",
                                 label="xls reads the file and ignores unused arguments with warning")
})


unlink("iris.xlsx")
