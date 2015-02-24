context("Get File Extension")

test_that("File extension converted correctly", {
    expect_that(get_ext("hello.csv"), equals("csv"))
    expect_that(get_ext("hello.CSV"), equals("csv"))
    expect_that(get_ext("hello.sav.CSV"), equals("csv"))
})
