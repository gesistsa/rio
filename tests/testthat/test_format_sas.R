test_that("Export to and import from SAS (.xpt)", {
    withr::with_tempfile("mtcars_file", fileext = ".xpt", code = {
        export(mtcars, mtcars_file)
        expect_true(file.exists(mtcars_file))
        expect_true(is.data.frame(import(mtcars_file)))
    })
})

test_that("Export SAS (.sas7bdat)", {
    withr::with_tempfile("mtcars_file", fileext = ".sas7bdat", code = {
        suppressWarnings(export(mtcars, mtcars_file))
        expect_true(file.exists(mtcars_file))
    })
})
