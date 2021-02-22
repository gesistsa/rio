context("ODS imports/exports")
require("datasets")

test_that("Import from ODS", {
    skip_if_not_installed(pkg="readODS")
    ods0 <- import(system.file("examples", "mtcars.ods", package = "rio"))
    expect_warning(ods <- import(system.file("examples", "mtcars.ods"
                                             , package = "rio"),
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

unlink("iris.ods")
