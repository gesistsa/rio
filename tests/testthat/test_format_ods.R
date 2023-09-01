context("ODS imports/exports")
require("datasets")

test_that("Import from ODS", {
    skip_if_not_installed(pkg="readODS")
    ods0 <- import("../testdata/mtcars.ods")
    expect_warning(ods <- import("../testdata/mtcars.ods",
                                 sheet = 1, col_names = TRUE,
                                 path = 'ignored value',
                                 invalid_argument = 42),
                   "The following arguments were ignored for read_ods:\ninvalid_argument, path",
                   label = "ODS import ignores redundant and unknown arguments with a warning")
    expect_identical(ods0, ods, label = "ODS import ignored arguments don't affect output")
    expect_true(is.data.frame(ods), label = "ODS import returns data.frame")
    expect_true(identical(names(mtcars), names(ods)), label = "ODS import returns correct names")
    expect_true(identical(dim(mtcars), dim(ods)), label = "ODS import returns correct dimensions")
    expect_equivalent(ods, mtcars, label = "ODS import returns correct values")
})

test_that("Export to ODS", {
    skip_if_not_installed(pkg="readODS")
    expect_true(export(iris, "iris.ods") %in% dir())
})

test_that("... correctly passed #318", {
    skip_if_not_installed(pkg = "readODS")
    x <- tempfile(fileext = ".ods")
    rio::export(mtcars, file = x, sheet = "mtcars")
    expect_equal(readODS::list_ods_sheets(x), "mtcars")
})

unlink("iris.ods")
