context("Check Data Identical")

test_that("Data identical (text formats)", {
    expect_equivalent(import(export(mtcars, "mtcars.txt")), mtcars)
    expect_equivalent(import(export(mtcars, "mtcars.csv")), mtcars)
    expect_equivalent(import(export(mtcars, "mtcars.tsv")), mtcars)
    unlink("mtcars.txt")
    unlink("mtcars.csv")
    unlink("mtcars.tsv")
})

test_that("Data identical (R formats)", {
    expect_equivalent(import(export(mtcars, "mtcars.rds")), mtcars)
    expect_equivalent(import(export(mtcars, "mtcars.R")), mtcars)
    expect_equivalent(import(export(mtcars, "mtcars.RData")), mtcars)
    expect_equivalent(import(export(mtcars, "mtcars.R", format = "dump")), mtcars)
    unlink("mtcars.rds")
    unlink("mtcars.R")
    unlink("mtcars.RData")
})

test_that("Data identical (haven formats)", {
    expect_equivalent(import(export(mtcars, "mtcars.dta")), mtcars)
    expect_equivalent(import(export(mtcars, "mtcars.sav")), mtcars)
    unlink("mtcars.dta")
    unlink("mtcars.sav")
})

test_that("Data identical (Excel formats)", {
    expect_equivalent(import(export(mtcars, "mtcars.xlsx")), mtcars)
    unlink("mtcars.xlsx")
})

test_that("Data identical (other formats)", {
    expect_equivalent(import(export(mtcars, "mtcars.dbf")), mtcars)
    expect_equivalent(import(export(mtcars, "mtcars.json")), mtcars)
    expect_equivalent(import(export(mtcars, "mtcars.arff")), mtcars)
    #expect_equivalent(import(export(mtcars, "mtcars.xml")), mtcars)
    unlink("mtcars.dbf")
    unlink("mtcars.json")
    unlink("mtcars.arff")
})

test_that("Data identical (optional arguments)", {
    #expect_equivalent(import(export(mtcars, "mtcars.csv", format = "csv2"), format = "csv2"), mtcars)
    expect_equivalent(import(export(mtcars, "mtcars.csv"), nrows = 4), mtcars[1:4,])
    expect_equivalent(import(export(mtcars, "mtcars.csv", format = "tsv"), format = "tsv"), mtcars)
    expect_true(all.equal(import(export(mtcars, "mtcars", format = "csv"), format = "csv"), mtcars, check.attributes = FALSE))
    unlink("mtcars.csv")
    unlink("mtcars")
})
