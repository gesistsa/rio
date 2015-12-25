context("Convert")

test_that("Basic file conversion", {
    export(iris, "iris.dta")
    convert("iris.dta", "iris.csv")
    convert("iris.csv", "iris.dta")
    x <- import("iris.dta")
    expect_true(identical(names(iris), names(x)))
    expect_true(identical(dim(iris), dim(x)))
})

test_that("File conversion with arguments", {
    export(iris, "iris.csv", format = "tsv")
    convert("iris.csv", "iris.csv", in_opts = list(format = "tsv"))
    expect_true("iris.csv" %in% dir())
    expect_true(!("iris.tsv" %in% dir()))
    convert("iris.csv", "iris.tsv",
            in_opts = list(format = "tsv"), out_opts = list(format = "csv"))
    expect_true("iris.tsv" %in% dir())
})
