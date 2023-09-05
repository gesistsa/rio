context("Remote Files")

test_that("Import Remote Stata File", {
    f <- try(import("http://www.stata-press.com/data/r13/auto.dta"))
    if (!inherits(f, "try-error")) {
        expect_true(is.data.frame(f))
    }
})

test_that("Import Remote GitHub File", {
    rfile <- "https://raw.githubusercontent.com/leeper/rio/master/inst/examples/no_header.csv"
    rfile_imported1 <- try(import(rfile))
    if (!inherits(rfile_imported1, "try-error")) {
        expect_true(inherits(rfile_imported1, "data.frame"), label = "Import remote file (implied format)")
    }
    rfile_imported2 <- try(import(rfile, format = "csv"))
    if (!inherits(rfile_imported2, "try-error")) {
        expect_true(inherits(rfile_imported2, "data.frame"), label = "Import remote file (explicit format)")
    }

    lfile <- remote_to_local(rfile)
    if (!inherits(lfile, "try-error")) {
        expect_true(file.exists(lfile), label = "Remote file copied successfully")
        expect_true(inherits(import(lfile), "data.frame"), label = "Import local copy successfully")
    }
})

## test_that("Import Remote File from Shortened URL", {
##     skip_if_not_installed(pkg = "data.table")
##     shorturl <- try(import("https://raw.githubusercontent.com/gesistsa/rio/main/tests/testdata/example.csvy"))
##     if (!inherits(shorturl, "try-error")) {
##         expect_true(inherits(shorturl, "data.frame"), label = "Import remote file")
##     }
## })

test_that("Import from Google Sheets", {
    googleurl1 <- "https://docs.google.com/spreadsheets/d/1I9mJsS5QnXF2TNNntTy-HrcdHmIF9wJ8ONYvEJTXSNo/edit#gid=0"
    expect_true(inherits(import(googleurl1), "data.frame"), label = "Import google sheets (specified sheet)")

    googleurl2 <- "https://docs.google.com/spreadsheets/d/1I9mJsS5QnXF2TNNntTy-HrcdHmIF9wJ8ONYvEJTXSNo/edit"
    expect_true(inherits(import(googleurl2), "data.frame"), label = "Import google sheets (unspecified sheet)")

    expect_true(inherits(import(googleurl1, format = "tsv"), "data.frame"), label = "Import google sheets (specified sheet, specified format)")
})
