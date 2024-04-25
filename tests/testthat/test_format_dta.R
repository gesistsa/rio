test_that("Export to Stata", {
    withr::with_tempfile("mtcars_file", fileext = ".dta", code = {
        export(mtcars, mtcars_file)
        expect_true(file.exists(mtcars_file))
        mtcars3 <- mtcars
        names(mtcars3)[1] <- "foo.bar"
        expect_error(export(mtcars3, mtcars_file), label = "Export fails on invalid Stata names")
    })
})

test_that("Import from Stata (read_dta)", {
    withr::with_tempfile("mtcars_file", fileext = ".dta", code = {
        export(mtcars, mtcars_file)
        expect_true(is.data.frame(import(mtcars_file)))
        ## arguments ignored
        expect_error(import(mtcars_file, extraneous.argument = TRUE), NA)
        expect_silent(import(mtcars_file,extraneous.argument = TRUE))
    })
})

test_that("Import from Stata with extended Haven features (read_dta)", {
    withr::with_tempfile("mtcars_file", fileext = ".dta", code = {
        export(mtcars, mtcars_file)

        expect_true(is.data.frame(mtcars_wtam <- import(mtcars_file,
                                                        col_select = c("wt", "am"),
                                                        n_max = 10
                                                        )))
        expect_identical(c(10L, 2L), dim(mtcars_wtam))
        expect_identical(c("wt", "am"), names(mtcars_wtam))
    })
})

test_that("haven is deprecated", {
    withr::with_tempfile("mtcars_file", fileext = ".dta", code = {
        export(mtcars, mtcars_file)
        lifecycle::expect_deprecated(import(mtcars_file, haven = TRUE))
        lifecycle::expect_deprecated(import(mtcars_file, haven = FALSE))
    })
})
