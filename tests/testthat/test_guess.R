test_that("File extension converted correctly", {
    expect_that(get_ext("hello.csv"), equals("csv"))
    expect_that(get_ext("hello.CSV"), equals("csv"))
    expect_that(get_ext("hello.sav.CSV"), equals("csv"))
    expect_that(get_ext("clipboard"), equals("clipboard"))
    expect_error(get_ext(1L))
})

test_that("Format converted correctly", {
    expect_that(.standardize_format(","), equals("csv"))
    expect_that(.standardize_format(";"), equals("csv2"))
    expect_that(.standardize_format("|"), equals("psv"))
    expect_that(.standardize_format("\t"), equals("tsv"))
    expect_that(.standardize_format("excel"), equals("xlsx"))
    expect_that(.standardize_format("stata"), equals("dta"))
    expect_that(.standardize_format("spss"), equals("sav"))
    expect_that(.standardize_format("sas"), equals("sas7bdat"))
})

test_that("Export without file specified", {
    withr::with_tempdir(code = {
        project_path <- getwd()
        export(iris, format = "csv")
        expect_true(file.exists(file.path(project_path, "iris.csv")))
    })
})

test_that(".check_pkg_availability", {
    expect_error(.check_pkg_availability("nonexistingpkg1233222"), "Suggested package `nonexisting")
    expect_error(.check_pkg_availability("rio"), NA)
})
