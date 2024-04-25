skip_if_not_installed("xml2")

test_xml <- function(breaker = "&") {
    mtcars2 <- mtcars
    colnames(mtcars2)[1] <- paste0("mp", breaker, breaker, "g")
    mtcars2[1,1] <- paste0("mp", breaker, breaker, "g")
    withr::with_tempfile("mtcars_file", fileext = ".xml", code = {
        expect_error(x <- rio::export(mtcars2, mtcars_file), NA)
        temp_df <- rio::import(mtcars_file)
        expect_equal(colnames(temp_df)[1], paste0("mp..g"))
        expect_equal(temp_df[1,1], paste0("mp", breaker, breaker, "g"))
    })
}

test_that("Export to and import from XML", {
    withr::with_tempfile("iris_file", fileext = ".xml", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})

test_that("Export to XML with &, >, ', \", >, <",{
    ## test all
    useless <- lapply(c("&", "\"", "'", "<", ">"), test_xml)
})
