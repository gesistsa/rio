context("Gather attrs")

e <- import("http://www.stata-press.com/data/r13/auto.dta")

test_that("Gather attrs from Stata", {
    g <- gather_attrs(e)
    expect_true(length(attributes(e[[1]])) >= 1)
    expect_true(length(attributes(g[[1]])) == 0)
    expect_true(length(attributes(e)) == 5)
    expect_true(length(attributes(g)) == 8)
    expect_true("label" %in% names(attributes(e[[1]])))
    expect_true(!"label" %in% names(attributes(g[[1]])))
    expect_true("label" %in% names(attributes(g)))
    expect_true("labels" %in% names(attributes(g)))
})

test_that("Spread gathered attributes", {
    g <- gather_attrs(e)
    expect_true(all.equal(spread_attrs(g), e, check.attributes = TRUE))
})

test_that("Gather empty attributes", {
    require("datasets")
    g <- gather_attrs(iris)
    expect_true(length(attributes(iris[[1]])) == 0)
    expect_true(length(attributes(g[[1]])) == 0)
    expect_true(length(attributes(iris)) == 3)
    expect_true(length(attributes(g)) == 3)
})

test_that("gather_attrs() fails on non-data frame", {
    expect_error(gather_attrs(letters))
})

rm(e)
