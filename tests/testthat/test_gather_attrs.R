e <- try(import("http://www.stata-press.com/data/r13/auto.dta"))

if (!inherits(e, "try-error")) {

    g <- gather_attrs(e)
    test_that("Gather attrs from Stata", {
        expect_true(length(attributes(e[[1]])) >= 1)
        expect_true(length(attributes(g[[1]])) == 0)
        expect_true(length(attributes(e)) == 5)
        expect_true(length(attributes(g)) == 8)
        expect_true("label" %in% names(attributes(e[[1]])))
        expect_true(!"label" %in% names(attributes(g[[1]])))
        expect_true("label" %in% names(attributes(g)))
        expect_true("labels" %in% names(attributes(g)))
        expect_true("format.stata" %in% names(attributes(g)))
        expect_true(!"format.stata" %in% names(attributes(g[[1]])))
    })

    test_that("Spread attrs from Stata", {
        s <- spread_attrs(g)
        # df-level attributes
        expect_true("label" %in% names(attributes(s)))
        expect_true("notes" %in% names(attributes(s)))
        # spread attributes
        expect_true("format.stata" %in% names(attributes(s[[1]])))
        expect_true(!"format.stata" %in% names(attributes(s)))
        expect_true("label" %in% names(attributes(s[[1]])))
        expect_true(!"labels" %in% names(attributes(s)))
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

    test_that("spread_attrs() fails on non-data frame", {
        expect_error(spread_attrs(letters))
    })
}
