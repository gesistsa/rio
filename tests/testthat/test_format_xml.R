context("XML imports/exports")
require("datasets")

test_xml <- function(breaker = "&") {
    mtcars2 <- mtcars
    colnames(mtcars2)[1] <- paste0("mp", breaker, breaker, "g")
    mtcars2[1,1] <- paste0("mp", breaker, breaker, "g")
    expect_error(x <- rio::export(mtcars2, tempfile(fileext = ".xml")), NA)
    temp_df <- rio::import(x)
    expect_equal(colnames(temp_df)[1], paste0("mp..g"))
    expect_equal(temp_df[1,1], paste0("mp", breaker, breaker, "g"))
}

test_that("Export to XML", {
    skip_if_not_installed("xml2")
    #skip("temporarily skipping (https://github.com/r-lib/xml2/issues/339)")
    expect_true(export(iris, "iris.xml") %in% dir())})

test_that("Export to XML with &, >, ', \", >, <",{
    skip_if_not_installed("xml2")
    ## test all
    useless <- lapply(c("&", "\"", "'", "<", ">"), test_xml)

})

test_that("Import from XML", {
    skip_if_not_installed("xml2")
    skip("temporarily skipping (https://github.com/r-lib/xml2/issues/339)")
    expect_true(is.data.frame(import("iris.xml")))
})

unlink(c("iris.xml","iris2.xml"))
