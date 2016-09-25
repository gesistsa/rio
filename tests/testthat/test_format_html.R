context("HTML imports/exports")
require("datasets")

test_that("Export to HTML", {
    expect_true(export(iris, "iris.html") %in% dir(), label = "export to html works")
})

test_that("Import from HTML", {
    expect_true(is.data.frame(import("iris.html")), label = "import from single-table html works")
    f <- system.file("examples", "twotables.html", package = "rio")
    expect_true(all(dim(import(f, which = 1)) == c(32, 11)), label = "import from two-table html works (which = 1)")
    expect_true(all(dim(import(f, which = 2)) == c(150, 5)), label = "import from two-table html works (which = 2)")
})

unlink("iris.html")
