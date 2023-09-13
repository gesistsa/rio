test_that("mapping; both base and tidy conventions work", {
    tempxlsx <- tempfile(fileext = ".xlsx")
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

test_that("Unused arguments are by default ignored silently", {
    tempxlsx <- tempfile(fileext = ".xlsx")
    export(list("mtcars" = mtcars, "iris" = iris), tempxlsx)
    expect_error(y <- import(tempxlsx, n_max = 42, whatever = TRUE), NA)
})

test_that("Unused arguments with option", {
    tempxlsx <- tempfile(fileext = ".xlsx")
    export(list("mtcars" = mtcars, "iris" = iris), tempxlsx)
    expect_error(R.utils::withOptions({
        expect_error(y <- import(tempxlsx, n_max = 42, whatever = TRUE), NA)
    }, rio.ignoreunusedargs = FALSE))
})
