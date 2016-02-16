context("Remote Files")

test_that("Import Remote Stata File", {
    expect_true(is.data.frame(import("http://www.stata-press.com/data/r13/auto.dta")))
})

test_that("Import Remote GitHub File", {
    rfile <- "https://raw.githubusercontent.com/leeper/rio/master/inst/examples/example.csvy"
    expect_true(inherits(import(rfile), "data.frame"), label = "Import remote file")
    
    lfile <- remote_to_local(rfile)
    expect_true(file.exists(lfile), label = "Remote file copied successfully")
    expect_true(inherits(import(lfile), "data.frame"), label = "Import local copy successfully")
})

test_that("Import Remote File from Shortened URL", {
    shorturl <- "https://goo.gl/KPFiaK"
    expect_true(inherits(import(shorturl), "data.frame"), label = "Import remote file")
})

test_that("Import from Google Sheets", {
    googleurl <- "https://docs.google.com/spreadsheets/d/1I9mJsS5QnXF2TNNntTy-HrcdHmIF9wJ8ONYvEJTXSNo/edit#gid=0"
    expect_true(inherits(import(googleurl), "data.frame"), label = "Import google sheets")
})
