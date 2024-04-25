skip_if_not_installed("xml2")

test_html <- function(breaker = "&") {
    mtcars2 <- mtcars
    colnames(mtcars2)[1] <- paste0("mp", breaker, breaker, "g")
    mtcars2[1,1] <- paste0("mp", breaker, breaker, "g")
    withr::with_tempfile("mtcars_file", fileext = ".html", code = {
        expect_error(x <- rio::export(mtcars2, mtcars_file), NA)
        temp_df <- rio::import(x)
        expect_equal(colnames(temp_df)[1], paste0("mp", breaker, breaker, "g"))
        expect_equal(temp_df[1,1], paste0("mp", breaker, breaker, "g"))
    })
}

test_that("Export to and import from HTML", {
    withr::with_tempfile("iris_file", fileext = ".html", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)), label = "import from single-table html works")
    })
})

test_that("Export to HTML with ampersands",{
    withr::with_tempfile("iris_file", fileext = ".html", code = {

        iris$`R & D` <- paste(sample(letters,nrow(iris),rep = TRUE),
                              "&",
                              sample(LETTERS,nrow(iris),rep = TRUE))
        export(iris, iris_file)
        expect_true(file.exists(iris_file),
                    label = "export to html with ampersands works")
    })
})

test_that("Import from HTML", {
    f <- "../testdata/twotables.html"
    expect_true(all(dim(import(f, which = 1)) == c(32, 11)), label = "import from two-table html works (which = 1)")
    expect_true(all(dim(import(f, which = 2)) == c(150, 5)), label = "import from two-table html works (which = 2)")
})

test_that("Import from HTML with multiple tbody elements", {
    expect_true(is.data.frame(import("../testdata/two-tbody.html")), label="import with two tbody elements in a single html table works")
    expect_true(is.data.frame(import("../testdata/br-in-header.html")), label="import with an empty header cell in an html table works")
    expect_true(is.data.frame(import("../testdata/br-in-td.html")), label="import with an empty data cell in a single html table works")
    expect_true(is.data.frame(import("../testdata/th-as-row-element.html")), label="import with th instead of td in a non-header row in a single html table works")
})

test_that("html with &, >, ', \", >, <", {
    ## test all
    useless <- lapply(c("&", "\"", "'", "<", ">"), test_html)
})
