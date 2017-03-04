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
})

test_that("Set object class as data.table", {
    expect_true(inherits(set_class(mtcars, class = "data.table"), "data.table"))
})
