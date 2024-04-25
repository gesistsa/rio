mtcars_tibble <- tibble::as_tibble(mtcars)
mtcars_datatable <- data.table::as.data.table(mtcars)

test_that("Set object class", {
    mtcars_tibble <- tibble::as_tibble(mtcars)
    mtcars_datatable <- data.table::as.data.table(mtcars)
    expect_true(inherits(set_class(mtcars), "data.frame"))
    expect_true(inherits(set_class(mtcars_tibble), "data.frame"))
    expect_true(inherits(set_class(mtcars_datatable), "data.frame"))
    expect_true(inherits(set_class(mtcars, class = "fakeclass"), "data.frame"))
    expect_true(!"fakeclass" %in% class(set_class(mtcars, class = "fakeclass")))
})

test_that("Set object class as tibble", {
    mtcars_tibble <- tibble::as_tibble(mtcars)
    mtcars_datatable <- data.table::as.data.table(mtcars)
    expect_true(inherits(set_class(mtcars, class = "tbl_df"), "tbl_df"))
    expect_true(inherits(set_class(mtcars, class = "tibble"), "tbl_df"))
    expect_true(inherits(set_class(mtcars_tibble, class = "tibble"), "tbl_df"))
})

test_that("Set object class as data.table", {
    expect_true(inherits(set_class(mtcars, class = "data.table"), "data.table"))
    withr::with_tempfile("data_file", fileext = ".csv", code = {
        export(mtcars, data_file)
        expect_true(inherits(import(data_file, setclass = "data.table"), "data.table"))
        expect_true(inherits(import(data_file, data.table = TRUE, setclass = "data.table"), "data.table"))
    })
})

test_that("Set object class as arrow table", {
    skip_if(getRversion() <= "4.2")
    skip_if_not_installed("arrow")
    mtcars_arrow <- arrow::arrow_table(mtcars)
    expect_false(inherits(set_class(mtcars_arrow), "data.frame")) ## arrow table is not data.frame
    expect_true(inherits(set_class(mtcars, class = "arrow"), "ArrowTabular"))
    expect_true(inherits(set_class(mtcars, class = "arrow_table"), "ArrowTabular"))
    withr::with_tempfile("data_file", fileext = ".csv", code = {
        export(mtcars, data_file)
        expect_true(inherits(import(data_file, setclass = "arrow"), "ArrowTabular"))
        expect_true(inherits(import(data_file, data.table = TRUE, setclass = "arrow"), "ArrowTabular"))
    })
})

test_that("ArrowTabular can be exported", {
    skip_if(getRversion() <= "4.2")
    skip_if_not_installed("arrow")
    mtcars_arrow <- arrow::arrow_table(mtcars)
    withr::with_tempfile("data_file", fileext = ".csv", code = {
        expect_error(export(mtcars_arrow, data_file), NA) ## no concept of rownames
        expect_true(inherits(import(data_file), "data.frame"))
    })
})

test_that("Simulate arrow is not installed, #376", {
    ## although this is pretty meaningless
    withr::with_tempfile("data_file", fileext = ".csv", code = {
        with_mocked_bindings({
            export(mtcars, data_file)
            expect_error(import(data_file, setclass = "arrow"), "Suggested package")
        }, .check_pkg_availability = function(pkg, lib.loc = NULL) {
            stop("Suggested package `", pkg, "` is not available. Please install it individually or use `install_formats()`", call. = FALSE)
        })
    })
})
