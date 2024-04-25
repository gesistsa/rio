test_that("mapping; both base and tidy conventions work", {
    withr::with_tempfile("tempxlsx", fileext = ".xlsx", code = {
        export(list("mtcars" = mtcars, "iris" = iris), tempxlsx)
        expect_error(y <- import(tempxlsx, n_max = 42, sheet = "iris"), NA)
        expect_equal(nrow(y), 42)
        expect_error(y2 <- import(tempxlsx, n_max = 42, which = "iris"), NA)
        expect_equal(nrow(y2), 42)
        expect_equal(y, y2)
        expect_error(y <- import(tempxlsx, n_max = 42, col_names = FALSE, which = 2), NA)
        expect_equal(nrow(y), 42)
        expect_error(y2 <- import(tempxlsx, n_max = 42, header = FALSE, which = 2), NA)
        expect_equal(y, y2)
    })
})

test_that("Unused arguments are by default ignored silently", {
    withr::with_tempfile("tempxlsx", fileext = ".xlsx", code = {
        export(list("mtcars" = mtcars, "iris" = iris), tempxlsx)
        expect_error(y <- import(tempxlsx, n_max = 42, whatever = TRUE, sheet = 2), NA)
    })
})

test_that("Unused arguments with option", {
    withr::with_tempfile("tempxlsx", fileext = ".xlsx", code = {
        export(list("mtcars" = mtcars, "iris" = iris), tempxlsx)
        expect_error(R.utils::withOptions({
            y <- import(tempxlsx, n_max = 42, whatever = TRUE)
        }, rio.ignoreunusedargs = FALSE))
        expect_error(R.utils::withOptions({
            y <- import(tempxlsx, n_max = 42, sheet = 2, whatever = TRUE)
        }, rio.ignoreunusedargs = FALSE), "whatever") ## not sheet
    })
})
