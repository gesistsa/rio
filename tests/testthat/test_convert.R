library("datasets")

test_that("Basic file conversion", {
    withr::with_tempfile("mtcars_files", fileext = c(".dta", ".csv"), code = {
        export(mtcars, mtcars_files[1])
        convert(mtcars_files[1], mtcars_files[2])
        convert(mtcars_files[2], mtcars_files[1])
        x <- import(mtcars_files[1])
        expect_true(identical(names(mtcars), names(x)))
        expect_true(identical(dim(mtcars), dim(x)))
    })
})

test_that("File conversion with arguments", {
    withr::with_tempfile("mtcars_files", fileext = c(".csv", ".tsv"), code = {
        export(mtcars, mtcars_files[1], format = "tsv")
        convert(mtcars_files[1], mtcars_files[1], in_opts = list(format = "tsv"))
        expect_true(file.exists(mtcars_files[1]))
        expect_true(!file.exists(mtcars_files[2]))
        convert(mtcars_files[1], mtcars_files[2],
                in_opts = list(format = "tsv"), out_opts = list(format = "csv"))
        expect_true(file.exists(mtcars_files[2]))
    })
})

test_that("File conversion w/o out_file errors", {
    withr::with_tempfile("mtcars_file", fileext = ".dta", {
        export(mtcars, mtcars_file)
        expect_error(convert(mtcars_file))
    })
})
