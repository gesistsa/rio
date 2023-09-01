context("YAML imports/exports")
require("datasets")

test_that("Export to YAML", {
    skip_if_not_installed("yaml")
    expect_true(export(iris, "iris.yml") %in% dir())
})

test_that("Import from YAML", {
    skip_if_not_installed("yaml")
    expect_true(is.data.frame(import("iris.yml")))
    expect_identical(import("iris.yml")[, 1:4], iris[, 1:4])
    expect_identical(import("iris.yml")$Species, as.character(iris$Species))
})

test_that("utf-8", {
    skip_if(getRversion() <= "4.2")
    content <- c("\"", "\u010d", "\u0161", "\u00c4", "\u5b57", "\u30a2", "\u30a2\u30e0\u30ed")
    x <- data.frame(col = content)
    tempyaml <- tempfile(fileext = ".yaml")
    y <- import(export(x, tempyaml))
    testthat::expect_equal(content, y$col)
})


unlink("iris.yml")
