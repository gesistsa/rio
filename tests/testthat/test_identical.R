test_that("Data identical (text formats)", {
    withr::with_tempdir(code = {
        expect_equivalent(import(export(mtcars, "mtcars.txt")), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.csv")), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.tsv")), mtcars)
    })
})

test_that("Data identical (R formats)", {
    withr::with_tempdir(code = {
        expect_equivalent(import(export(mtcars, "mtcars.rds"), trust = TRUE), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.R"), trust = TRUE), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.RData"), trust = TRUE), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.R", format = "dump"), trust = TRUE), mtcars)
    })
})

test_that("Data identical (R formats), feather", {
    skip_if_not_installed("arrow")
    withr::with_tempdir(code = {
        expect_equivalent(import(export(mtcars, "mtcars.feather")), mtcars)
    })
})

test_that("Data identical (haven formats)", {
    withr::with_tempdir(code = {
        expect_equivalent(import(export(mtcars, "mtcars.dta")), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.sav")), mtcars)
    })
})

test_that("Data identical (Excel formats)", {
    withr::with_tempdir(code = {
        expect_equivalent(import(export(mtcars, "mtcars.xlsx")), mtcars)
    })
})

test_that("Data identical (other formats)", {
    skip_if_not_installed("xml2")
    skip_if_not_installed("jsonlite")
    withr::with_tempdir(code = {
        expect_equivalent(import(export(mtcars, "mtcars.dbf")), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.json")), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.arff")), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.xml")), mtcars)
    })
})

test_that("Data identical (optional arguments)", {
    withr::with_tempdir(code = {
        ##expect_equivalent(import(export(mtcars, "mtcars.csv", format = "csv2"), format = "csv2"), mtcars)
        expect_equivalent(import(export(mtcars, "mtcars.csv"), nrows = 4), mtcars[1:4,])
        expect_equivalent(import(export(mtcars, "mtcars.csv", format = "tsv"), format = "tsv"), mtcars)
        expect_true(all.equal(import(export(mtcars, "mtcars", format = "csv"), format = "csv"), mtcars, check.attributes = FALSE))
    })
})
