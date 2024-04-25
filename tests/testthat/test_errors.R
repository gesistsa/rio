library("datasets")

test_that("Function suggestions for unsupported export", {
    expect_error(export(data.frame(1), "test.jpg"),
                 "jpg format not supported. Consider using the 'jpeg::writeJPEG()' function",
                 fixed = TRUE)
})

test_that("Error for unsupported file types", {
    withr::with_tempfile("test_file", fileext = ".faketype", code = {
        writeLines("123", con = test_file)
        expect_error(import(test_file), "Format not supported")
        expect_error(export(mtcars, test_file), "Format not supported")
    })
    expect_equal(.standardize_format("faketype"), "faketype")
    expect_error(get_ext("noextension"), "'file' has no extension")
})

test_that("Error for mixed support file types", {
    expect_error(import("test.por"), "No such file")
    withr::with_tempfile("mtcars_file", fileext = ".por", code = {
        expect_error(export(mtcars, mtcars_file), "Format not supported")
    })
})

test_that("Only export data.frame or matrix", {
    withr::with_tempfile("test_file", fileext = ".csv", code = {
        expect_error(export(1, test_file), "'x' is not a data.frame or matrix")
    })
})

test_that("Column widths printed for fixed-width format", {
    withr::with_tempfile("test_file", fileext = ".txt", code = {
        expect_true(is.character(export(data.frame(1), test_file, format = "fwf", verbose = FALSE)))
        expect_message(export(data.frame(1), test_file, format = "fwf", verbose = TRUE))
    })
})

test_that("Warning for import_list() with missing file", {
    expect_warning(import_list("fake_file.csv")) ## no error
})
