context("HTML imports/exports")
require("datasets")

test_that("Export to HTML", {
    skip_if_not_installed("xml2")
    expect_true(export(iris, "iris.html") %in% dir(), label = "export to html works")
})

test_that("Export to HTML with ampersands",{
  skip_if_not_installed("xml2")
  iris$`R & D` <- paste(sample(letters,nrow(iris),rep=T),
                        '&',
                        sample(LETTERS,nrow(iris),rep=TRUE))
  expect_true(export(iris, "iris2.html") %in% dir(),
              label = "export to html with ampersands works")
})

test_that("Import from HTML", {
    skip_if_not_installed("xml2")
    expect_true(is.data.frame(import("iris.html")), label = "import from single-table html works")
    f <- "../testdata/twotables.html"
    expect_true(all(dim(import(f, which = 1)) == c(32, 11)), label = "import from two-table html works (which = 1)")
    expect_true(all(dim(import(f, which = 2)) == c(150, 5)), label = "import from two-table html works (which = 2)")
})

test_that("Import from HTML with multiple tbody elements", {
    skip_if_not_installed("xml2")
    expect_true(is.data.frame(import("../testdata/two-tbody.html")), label="import with two tbody elements in a single html table works")
    expect_true(is.data.frame(import("../testdata/br-in-header.html")), label="import with an empty header cell in an html table works")
    expect_true(is.data.frame(import("../testdata/br-in-td.html")), label="import with an empty data cell in a single html table works")
    expect_true(is.data.frame(import("../testdata/th-as-row-element.html")), label="import with th instead of td in a non-header row in a single html table works")
})

unlink(c("iris.xml", "iris2.xml", "iris2.html"))
