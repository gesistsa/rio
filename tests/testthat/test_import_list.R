context("Test import_list()")
library("datasets")

export(list(mtcars = mtcars, iris = iris), "data.rdata")
export(mtcars, "mtcars.rds")

test_that("Data identical (import_list)", {
    expect_equivalent(import_list(rep("mtcars.rds", 2)), list(mtcars, mtcars))
    mdat <- rbind(mtcars, mtcars)
    dat <- import_list(rep("mtcars.rds", 2), rbind = TRUE)
    expect_true(ncol(dat) == ncol(mdat) + 1)
    expect_true(nrow(dat) == nrow(mdat))
    expect_true("_file" %in% names(dat))
})

test_that("Import multi-object .Rdata in import_list()", {
    dat <- import_list("data.rdata")
    expect_true(identical(dat[[1]], mtcars))
    expect_true(identical(dat[[2]], iris))
})

test_that("Import multiple HTML tables in import_list()", {
    dat <- import_list("../testdata/twotables.html")
    expect_true(identical(dim(dat[[1]]), dim(mtcars)))
    expect_true(identical(names(dat[[1]]), names(mtcars)))
    expect_true(identical(dim(dat[[2]]), dim(iris)))
    expect_true(identical(names(dat[[2]]), names(iris)))
})

test_that("Import multiple HTML tables in import_list() but with htm #350", {
    temphtm <- tempfile(fileext = ".htm")
    file.copy("../testdata/twotables.html", temphtm)
    dat <- import_list(temphtm)
    expect_true(identical(dim(dat[[1]]), dim(mtcars)))
    expect_true(identical(names(dat[[1]]), names(mtcars)))
    expect_true(identical(dim(dat[[2]]), dim(iris)))
    expect_true(identical(names(dat[[2]]), names(iris)))
})


test_that("import_list() preserves 'which' names when specified", {
    export(list(a = mtcars, b = iris), "foo.xlsx")
    expect_true(identical(names(import_list("foo.xlsx")), c("a", "b")))
    expect_true(identical(names(import_list("foo.xlsx", which = 1)), "a"))
    expect_true(identical(names(import_list("foo.xlsx", which = "a")), "a"))
    expect_true(identical(names(import_list("foo.xlsx", which = 2)), "b"))
    expect_true(identical(names(import_list("foo.xlsx", which = "b")), "b"))
    expect_true(identical(names(import_list("foo.xlsx", which = 1:2)), c("a", "b")))
    expect_true(identical(names(import_list("foo.xlsx", which = 2:1)), c("b", "a")))
    expect_true(identical(names(import_list("foo.xlsx", which = c("a", "b"))), c("a", "b")))
    expect_true(identical(names(import_list("foo.xlsx", which = c("b", "a"))), c("b", "a")))
    unlink("foo.xlsx")
})

test_that("Import single file via import_list()", {
    expect_true(identical(import_list("mtcars.rds", rbind = TRUE), mtcars))
})

test_that("Import single file from zip via import_list()", {
    export(mtcars, "mtcars.csv.zip", format = "csv")
    expect_true(inherits(import_list("mtcars.csv.zip")[[1L]], "data.frame"))
    expect_true(inherits(import_list("mtcars.csv.zip", which = 1)[[1L]], "data.frame"))
    expect_true(inherits(import_list("mtcars.csv.zip", which = "mtcars.csv")[[1L]], "data.frame"))
})

test_that("Using setclass in import_list()", {
    dat1 <- import_list(rep("mtcars.rds", 2), setclass = "data.table", rbind = TRUE)
    expect_true(inherits(dat1, "data.table"))
    dat2 <- import_list(rep("mtcars.rds", 2), setclass = "tbl", rbind = TRUE)
    expect_true(inherits(dat2, "tbl"))
})

test_that("Object names are preserved by import_list()", {
    export(list(mtcars1 = mtcars[1:10,],
                mtcars2 = mtcars[11:20,],
                mtcars3 = mtcars[21:32,]), "mtcars.xlsx")
    export(mtcars[1:10,],  "mtcars1.csv")
    export(mtcars[11:20,], "mtcars2.tsv")
    export(mtcars[21:32,], "mtcars3.csv")
    expected_names <- c("mtcars1", "mtcars2", "mtcars3")
    dat_xls <- import_list("mtcars.xlsx")
    dat_csv <- import_list(c("mtcars1.csv","mtcars2.tsv","mtcars3.csv"))

    expect_identical(names(dat_xls), expected_names)
    expect_identical(names(dat_csv), expected_names)

    unlink(c("mtcars.xlsx", "mtcars1.csv","mtcars2.tsv","mtcars3.csv"))
})

test_that("File names are added as attributes by import_list()", {
    export(mtcars[1:10,],  "mtcars.csv")
    export(mtcars[11:20,], "mtcars.tsv")
    expected_names <- c("mtcars", "mtcars")
    expected_attrs <- c(mtcars = "mtcars.csv", mtcars = "mtcars.tsv")
    dat <- import_list(c("mtcars.csv","mtcars.tsv"))

    expect_identical(names(dat), expected_names)
    expect_identical(unlist(lapply(dat, attr, "filename")), expected_attrs)

    unlink(c("mtcars.csv", "mtcars.tsv"))
})

test_that("URL #294", {
    skip_on_cran()
    ## url <- "https://evs.nci.nih.gov/ftp1/CDISC/SDTM/SDTM%20Terminology.xls" That's 10MB!
    url <- "https://github.com/tidyverse/readxl/raw/main/tests/testthat/sheets/sheet-xml-lookup.xlsx"
    expect_error(x <- import_list(url), NA)
    expect_true(inherits(x, "list"))
    expect_true("Asia" %in% names(x))
    expect_true("Africa" %in% x[[1]]$continent)
    expect_false("Africa" %in% x[[2]]$continent)
    ## double URLs; it reads twice the first sheet by default
    urls <- c(url, url)
    expect_error(x2 <- import_list(urls), NA)
    expect_true("sheet-xml-lookup" %in% names(x2))
    expect_true("Africa" %in% x2[[1]]$continent)
    expect_true("Africa" %in% x2[[2]]$continent)
})

test_that("Universal dummy `which` #326", {
    formats <- c("xlsx", "dta", "sav", "csv", "csv2")
    for (format in formats) {
        tempzip <- tempfile(fileext = paste0(".", format, ".zip"))
        rio::export(mtcars, tempzip, format = format)
        expect_warning(rio::import(tempzip), NA)
        expect_warning(rio::import_list(tempzip), NA)
    }
})

test_that("Universal dummy `which` (Suggests) #326", {
    skip_if_not_installed("qs")
    skip_if_not_installed("arrow")
    skip_if_not_installed("readODS")
    formats <- c("qs", "parquet", "ods")
    for (format in formats) {
        tempzip <- tempfile(fileext = paste0(".", format, ".zip"))
        rio::export(mtcars, tempzip, format = format)
        expect_warning(rio::import(tempzip), NA)
        expect_warning(rio::import_list(tempzip), NA)
    }
})

unlink("data.rdata")
unlink("mtcars.rds")
unlink("mtcars.csv.zip")
