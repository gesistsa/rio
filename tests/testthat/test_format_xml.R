context("XML imports/exports")
require("datasets")

test_that("Export to XML", {
    skip_if_not_installed("xml2")
    skip("temporarily skipping (https://github.com/r-lib/xml2/issues/339)")
    expect_true(export(iris, "iris.xml") %in% dir())})

test_that("Export to XML with ampersands",{
    skip_if_not_installed("xml2")
    skip("temporarily skipping (https://github.com/r-lib/xml2/issues/339)")
    iris$`R & D` <- paste(sample(letters,nrow(iris),rep=T),
                          '&',
                          sample(LETTERS,nrow(iris),rep=TRUE))
    expect_true(export(iris, "iris2.xml") %in% dir())
})

test_that("Import from XML", {
    skip_if_not_installed("xml2")
    skip("temporarily skipping (https://github.com/r-lib/xml2/issues/339)")
    expect_true(is.data.frame(import("iris.xml")))
})

unlink(c("iris.xml","iris2.xml"))
