context("Set object class")

test_that("Set object class", {
    x <- list(a = 1:5)
    expect_true(inherits(set_class(x), "data.frame"))
    expect_true(inherits(set_class(x, class = "fakeclass"), "data.frame"))
    expect_true("tbl_df" %in% class(set_class(x, class = "tbl_df")))
    expect_true("data.table" %in% class(set_class(x, class = "data.table")))
    expect_true("fakeclass" %in% class(set_class(x, class = "fakeclass")))
})
