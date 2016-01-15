context("Get File Extension")

test_that("File extension converted correctly", {
    expect_that(get_ext("hello.csv"), equals("csv"))
    expect_that(get_ext("hello.CSV"), equals("csv"))
    expect_that(get_ext("hello.sav.CSV"), equals("csv"))
    expect_that(get_ext("clipboard"), equals("clipboard"))
})

test_that("Format converted correctly", {
    expect_that(get_type(","), equals("csv"))
    expect_that(get_type(";"), equals("csv2"))
    expect_that(get_type("|"), equals("psv"))
    expect_that(get_type("\t"), equals("tsv"))
    expect_that(get_type("excel"), equals("xlsx"))
    expect_that(get_type("stata"), equals("dta"))
    expect_that(get_type("spss"), equals("sav"))
    expect_that(get_type("sas"), equals("sas7bdat"))
})
