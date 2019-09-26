context("YAML imports/exports")
require("datasets")

test_that("Export to YAML", {
    expect_true(export(iris, "iris.yml") %in% dir())
})

test_that("Import from YAML", {
    expect_true(is.data.frame(import("iris.yml")))
    expect_identical(import("iris.yml")[,1:4],iris[,1:4])
    expect_identical(import("iris.yml")$Species,as.character(iris$Species))
})

unlink("iris.yml")
