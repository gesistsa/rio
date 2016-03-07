context("Errors")
library("datasets")

test_that("Function suggestions for unsupported import and export", {
    #expect_error(import("test.jpg"), "jpg format not supported. Consider using the `jpeg::readJPEG` function")
    #expect_error(export(data.frame(1), "test.jpg"), "jpg format not supported. Consider using the `jpeg::writeJPEG` function")
})

test_that("Error for unsupported file types", {
    writeLines("123", con = "test.faketype")
    expect_error(import("test.faketype"), "Unrecognized file format")
    expect_error(export(mtcars, "mtcars.faketype"), "Unrecognized file format")
    expect_message(get_type("faketype"), "Unrecognized file format. Try specifying with the format argument.")
    expect_equal(get_type("faketype"), "faketype")
    expect_error(get_ext("noextension"), "'file' has no extension")
    unlink("test.faketype")
})

test_that("Error for mixed support file types", {
    expect_error(import("test.por"), "No such file")
    expect_error(export(mtcars, "mtcars.por"), "Unrecognized file format")
    expect_error(export(mtcars, "mtcars.faketype"), "Unrecognized file format")
})

test_that("Only export data.frame or matrix", {
    expect_error(export(1, "test.csv"), "'x' is not a data.frame or matrix")
})

test_that("Column widths printed for fixed-width format", {
    expect_message(export(data.frame(1), "test.txt", format = "fwf"))
    unlink("test.txt")
})
