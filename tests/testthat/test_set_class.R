context("Set object class")
library("datasets")
mtcars_tibble <- tibble::as_tibble(mtcars)
mtcars_datatable <- data.table::as.data.table(mtcars)

test_that("Set object class", {
    expect_true(inherits(set_class(mtcars), "data.frame"))
    expect_true(inherits(set_class(mtcars_tibble), "data.frame"))
    expect_true(inherits(set_class(mtcars_datatable), "data.frame"))
    expect_true(inherits(set_class(mtcars, class = "fakeclass"), "data.frame"))
    expect_true(!"fakeclass" %in% class(set_class(mtcars, class = "fakeclass")))
})

test_that("Set object class as tibble", {
    expect_true(inherits(set_class(mtcars, class = "tbl_df"), "tbl_df"))
    expect_true(inherits(set_class(mtcars, class = "tibble"), "tbl_df"))
    expect_true(inherits(set_class(mtcars_tibble, class = "tibble"), "tbl_df"))
})

test_that("Set object class as data.table", {
    expect_true(inherits(set_class(mtcars, class = "data.table"), "data.table"))
    export(mtcars, "mtcars.csv")
    expect_true(inherits(import("mtcars.csv", setclass = "data.table"), "data.table"))
    expect_true(inherits(import("mtcars.csv", data.table = TRUE, setclass = "data.table"), "data.table"))
    unlink("mtcars.csv")
})

test_that("Set object class as arrow table", {
    skip_if(getRversion() <= "4.2")
    skip_if_not_installed("arrow")
    mtcars_arrow <- arrow::arrow_table(mtcars)
    expect_false(inherits(set_class(mtcars_arrow), "data.frame")) ## arrow table is not data.frame
    expect_true(inherits(set_class(mtcars, class = "arrow"), "ArrowTabular"))
    expect_true(inherits(set_class(mtcars, class = "arrow_table"), "ArrowTabular"))
    export(mtcars, "mtcars.csv")
    expect_true(inherits(import("mtcars.csv", setclass = "arrow"), "ArrowTabular"))
    expect_true(inherits(import("mtcars.csv", data.table = TRUE, setclass = "arrow"), "ArrowTabular"))
    unlink("mtcars.csv")
})

test_that("ArrowTabular can be exported", {
    skip_if(getRversion() <= "4.2")
    skip_if_not_installed("arrow")
    mtcars_arrow <- arrow::arrow_table(mtcars)
    expect_error(export(mtcars_arrow, "mtcars.csv"), NA) ## no concept of rownames
    expect_true(inherits(import("mtcars.csv"), "data.frame"))
    unlink("mtcars.csv")
})

test_that("Simulate arrow is not installed, #376", {
    ## although this is pretty meaningless
    with_mocked_bindings({
        export(mtcars, "mtcars.csv")
        expect_error(import("mtcars.csv", setclass = "arrow"), "Suggested package")
    }, .check_pkg_availability = function(pkg, lib.loc = NULL) {
        stop("Suggested package `", pkg, "` is not available. Please install it individually or use `install_formats()`", call. = FALSE)
    })
})
