skip_if_not_installed("readODS")

test_that("Import from ODS", {
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

test_that("Export to and import from ODS", {
    withr::with_tempfile("iris_file", fileext = ".ods", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})

test_that("... correctly passed #318", {
    withr::with_tempfile("mtcars_file", fileext = ".ods", code = {
        export(iris, mtcars_file, sheet = "mtcars")
        expect_equal(readODS::list_ods_sheets(mtcars_file), "mtcars")
    })
})

test_that("Export and Import FODS", {
    withr::with_tempfile("fods_file", fileext = ".fods", code = {
        export(iris, fods_file)
        expect_true(file.exists(fods_file))
        expect_true(is.data.frame(import(fods_file)))
        export(iris, fods_file, sheet = "mtcars")
        expect_equal(readODS::list_fods_sheets(fods_file), "mtcars")
        expect_error(y <- import(fods_file), NA)
        expect_true(is.data.frame(y))

    })
})

test_that("Export list of data frames", {
    withr::with_tempfile("ods_files", fileext = c(".ods", ".fods"), code = {
        dfs <- list("cars" = mtcars, "flowers" = iris)
        expect_error(export(dfs, ods_files[1]), NA)
        expect_error(export(dfs, ods_files[2]), NA)
        expect_equal(import(ods_files[1], which = "flowers"), import(ods_files[2], which = "flowers"))
    })
})
