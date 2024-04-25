
test_that("Export to SPSS (.sav)", {
    mtcars2 <- mtcars
    ## label and value labels
    mtcars2[["cyl"]] <- factor(mtcars2[["cyl"]], c(4, 6, 8), c("four", "six", "eight"))
    attr(mtcars2[["cyl"]], "label") <- "cylinders"
    ## value labels only
    mtcars2[["am"]] <- factor(mtcars2[["am"]], c(0, 1), c("automatic", "manual"))
    ## variable label only
    attr(mtcars2[["mpg"]], "label") <- "miles per gallon"
    withr::with_tempfile("mtcars_file", fileext = ".sav", code = {
        export(mtcars2, mtcars_file)
        expect_true(file.exists(mtcars_file))
        expect_true(d <- is.data.frame(import(mtcars_file)))
        expect_true(!"labelled" %in% unlist(lapply(d, class)))
        ##Variable label and value labels preserved on SPSS (.sav) roundtrip
        d <- import(mtcars_file)
        a_cyl <- attributes(d[["cyl"]])
        expect_true("label" %in% names(a_cyl))
        expect_true("labels" %in% names(a_cyl))
        expect_true(identical(a_cyl[["label"]], "cylinders"))
        expect_true(identical(a_cyl[["labels"]], stats::setNames(c(1.0, 2.0, 3.0), c("four", "six", "eight"))))
        a_am <- attributes(d[["am"]])
        expect_true("labels" %in% names(a_am))
        expect_true(identical(a_am[["labels"]], stats::setNames(c(1.0, 2.0), c("automatic", "manual"))))

        a_mpg <- attributes(d[["mpg"]])
        expect_true("label" %in% names(a_mpg))
        expect_true(identical(a_mpg[["label"]], "miles per gallon"))
        ##haven is deprecated"
        lifecycle::expect_deprecated(import(mtcars_file, haven = TRUE))
        lifecycle::expect_deprecated(import(mtcars_file, haven = FALSE))
    })
})

test_that("Export to SPSS compressed (.zsav)", {
    mtcars2 <- mtcars
    ## label and value labels
    mtcars2[["cyl"]] <- factor(mtcars2[["cyl"]], c(4, 6, 8), c("four", "six", "eight"))
    attr(mtcars2[["cyl"]], "label") <- "cylinders"
    ## value labels only
    mtcars2[["am"]] <- factor(mtcars2[["am"]], c(0, 1), c("automatic", "manual"))
    ## variable label only
    attr(mtcars2[["mpg"]], "label") <- "miles per gallon"
    withr::with_tempfile("mtcars_file", fileext = ".zsav", code = {
        export(mtcars2, mtcars_file)
        expect_true(file.exists(mtcars_file))
        expect_true(d <- is.data.frame(import(mtcars_file)))
        expect_true(!"labelled" %in% unlist(lapply(d, class)))
        d <- import(mtcars_file)
        a_cyl <- attributes(d[["cyl"]])
        expect_true("label" %in% names(a_cyl))
        expect_true("labels" %in% names(a_cyl))
        expect_true(identical(a_cyl[["label"]], "cylinders"))
        expect_true(identical(a_cyl[["labels"]], stats::setNames(c(1.0, 2.0, 3.0), c("four", "six", "eight"))))

        a_am <- attributes(d[["am"]])
        expect_true("labels" %in% names(a_am))
        expect_true(identical(a_am[["labels"]], stats::setNames(c(1.0, 2.0), c("automatic", "manual"))))

        a_mpg <- attributes(d[["mpg"]])
        expect_true("label" %in% names(a_mpg))
        expect_true(identical(a_mpg[["label"]], "miles per gallon"))
    })
})
