context("ODS imports/exports")
require("datasets")

test_that("Import from ODS", {
    skip_if_not_installed(pkg="readODS")
    ods0 <- import("../testdata/mtcars.ods")
    expect_error(ods <- import("../testdata/mtcars.ods",
                               sheet = 1, col_names = TRUE,
                               invalid_argument = 42), NA)
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

test_that("Export and Import FODS", {
    skip_if_not_installed(pkg = "readODS")
    x <- tempfile(fileext = ".fods")
    rio::export(mtcars, file = x, sheet = "mtcars")
    expect_equal(readODS::list_fods_sheets(x), "mtcars")
    expect_error(y <- import(x), NA)
    expect_true(is.data.frame(y))
})

test_that("Export list of data frames", {
    skip_if_not_installed(pkg = "readODS")
    dfs <- list("cars" = mtcars, "flowers" = iris)
    x1 <- tempfile(fileext = ".ods")
    x2 <- tempfile(fileext = ".fods")
    expect_error(export(dfs, x1), NA)
    expect_error(export(dfs, x2), NA)
    expect_equal(import(x1, which = "flowers"), import(x2, which = "flowers"))
})

unlink("iris.ods")
