context("Set object class")
library("datasets")
mtcars_tibble <- tibble::as_tibble(mtcars)
mtcars_datatable <- data.table::as.data.table(mtcars)
mtcars_arrow <- arrow::as_arrow_table(mtcars)

test_that("Set object class", {
    expect_true(inherits(set_class(mtcars), "data.frame"))
    expect_true(inherits(set_class(mtcars_tibble), "data.frame"))
    expect_true(inherits(set_class(mtcars_datatable), "data.frame"))
    expect_false(inherits(set_class(mtcars_arrow), "data.frame")) ## arrow table is not data.frame
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
    expect_true(inherits(set_class(mtcars, class = "arrow"), "ArrowTabular"))
    expect_true(inherits(set_class(mtcars, class = "arrow_table"), "ArrowTabular"))
    export(mtcars, "mtcars.csv")
    expect_true(inherits(import("mtcars.csv", setclass = "arrow"), "ArrowTabular"))
    expect_true(inherits(import("mtcars.csv", data.table = TRUE, setclass = "arrow"), "ArrowTabular"))
    unlink("mtcars.csv")
})

test_that("ArrowTabular can be exported", {
    expect_error(export(mtcars_arrow, "mtcars.csv"), NA) ## no concept of rownames
    expect_true(inherits(import("mtcars.csv"), "data.frame"))
    unlink("mtcars.csv")
})
