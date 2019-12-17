context("XML imports/exports")
require("datasets")

test_that("Export to XML", {
    expect_true(export(iris, "iris.xml") %in% dir())})

test_that("Export to XML with ampersands",{
    iris$`R & D` <- paste(sample(letters,nrow(iris),rep=T),
                          '&',
                          sample(LETTERS,nrow(iris),rep=TRUE))
    expect_true(export(iris, "iris2.xml") %in% dir())
})

test_that("Import from XML", {
    expect_true(is.data.frame(import("iris.xml")))
})

unlink(c("iris.xml","iris2.xml"))
