test_that("Data identical (import_list)", {
    withr::with_tempfile("mtcars_file", fileext = ".rds", code = {
        export(mtcars, mtcars_file)
        expect_equivalent(import_list(rep(mtcars_file, 2), trust = TRUE), list(mtcars, mtcars))
        mdat <- rbind(mtcars, mtcars)
        dat <- import_list(rep(mtcars_file, 2), rbind = TRUE, trust = TRUE)
        expect_true(ncol(dat) == ncol(mdat) + 1)
        expect_true(nrow(dat) == nrow(mdat))
        expect_true("_file" %in% names(dat))
    })
})

test_that("Import multi-object .Rdata in import_list()", {
    withr::with_tempfile("rdata_file", fileext = ".rdata", code = {
        export(list(mtcars = mtcars, iris = iris), rdata_file)
        dat <- import_list(rdata_file, trust = TRUE)
        expect_true(identical(dat[[1]], mtcars))
        expect_true(identical(dat[[2]], iris))
    })
})

test_that("Import multiple HTML tables in import_list()", {
    dat <- import_list("../testdata/twotables.html")
    expect_true(identical(dim(dat[[1]]), dim(mtcars)))
    expect_true(identical(names(dat[[1]]), names(mtcars)))
    expect_true(identical(dim(dat[[2]]), dim(iris)))
    expect_true(identical(names(dat[[2]]), names(iris)))
})

test_that("Import multiple HTML tables in import_list() but with htm #350", {
    withr::with_tempfile("temphtm", fileext = ".htm", code = {
        temphtm <- tempfile(fileext = ".htm")
        file.copy("../testdata/twotables.html", temphtm)
        dat <- import_list(temphtm)
        expect_true(identical(dim(dat[[1]]), dim(mtcars)))
        expect_true(identical(names(dat[[1]]), names(mtcars)))
        expect_true(identical(dim(dat[[2]]), dim(iris)))
        expect_true(identical(names(dat[[2]]), names(iris)))
    })
})

test_that("import_list() preserves 'which' names when specified", {
    withr::with_tempfile("data_file", fileext = ".xlsx", code = {
        export(list(a = mtcars, b = iris), data_file)
        expect_true(identical(names(import_list(data_file)), c("a", "b")))
        expect_true(identical(names(import_list(data_file, which = 1)), "a"))
        expect_true(identical(names(import_list(data_file, which = "a")), "a"))
        expect_true(identical(names(import_list(data_file, which = 2)), "b"))
        expect_true(identical(names(import_list(data_file, which = "b")), "b"))
        expect_true(identical(names(import_list(data_file, which = 1:2)), c("a", "b")))
        expect_true(identical(names(import_list(data_file, which = 2:1)), c("b", "a")))
        expect_true(identical(names(import_list(data_file, which = c("a", "b"))), c("a", "b")))
        expect_true(identical(names(import_list(data_file, which = c("b", "a"))), c("b", "a")))
    })
})

test_that("import_list() preserves 'which' names when specified ods", {
    skip_if_not_installed("readODS")
    withr::with_tempfile("data_file", fileext = ".ods", code = {
        export(list(a = mtcars, b = iris), data_file)
        expect_true(identical(names(import_list(data_file)), c("a", "b")))
        expect_true(identical(names(import_list(data_file, which = 1)), "a"))
        expect_true(identical(names(import_list(data_file, which = "a")), "a"))
        expect_true(identical(names(import_list(data_file, which = 2)), "b"))
        expect_true(identical(names(import_list(data_file, which = "b")), "b"))
        expect_true(identical(names(import_list(data_file, which = 1:2)), c("a", "b")))
        expect_true(identical(names(import_list(data_file, which = 2:1)), c("b", "a")))
        expect_true(identical(names(import_list(data_file, which = c("a", "b"))), c("a", "b")))
        expect_true(identical(names(import_list(data_file, which = c("b", "a"))), c("b", "a")))
    })
})


test_that("Import single file via import_list()", {
    withr::with_tempfile("data_file", fileext = ".rds", code = {
        export(mtcars, data_file)
        expect_true(identical(import_list(data_file, rbind = TRUE, trust = TRUE), mtcars))
    })
})

test_that("Import single file from zip via import_list()", {
    withr::with_tempfile("data_file", fileext = ".csv.zip", code = {
        export(mtcars, data_file, format = "csv")
        expect_true(is.data.frame(import_list(data_file)[[1L]]))
        expect_true(is.data.frame(import_list(data_file, which = 1)[[1L]]))
        basefile_name <- gsub(".zip$", "", basename(data_file))
        expect_true(is.data.frame(import_list(data_file, which = basefile_name)[[1L]]))
    })
})

test_that("Import multiple files from zip via import_list()", {
    withr::with_tempfile("data_file", fileext = ".csv.zip", code = {
        mylist <- list(mtcars3 = mtcars[1:10, ], mtcars2 = mtcars[11:20, ], mtcars1 = mtcars[21:32, ])
        expect_error(export_list(mylist, file = paste0("mtcars", 1:3, ".csv"), archive = data_file), NA)
        expect_error(res <- import_list(data_file), NA)
        expect_true(is.list(res))
        expect_equal(length(res), 3)
        expect_true(is.data.frame(res[[1]]))
        expect_true(is.data.frame(res[[2]]))
        expect_true(is.data.frame(res[[3]]))
    })
})

test_that("Import multiple files from zip via import_list()", {
    skip_if(getRversion() <= "4.0")
    withr::with_tempfile("data_file", fileext = ".csv.tar.gz", code = {
        mylist <- list(mtcars3 = mtcars[1:10, ], mtcars2 = mtcars[11:20, ], mtcars1 = mtcars[21:32, ])
        expect_error(export_list(mylist, file = paste0("mtcars", 1:3, ".csv"), archive = data_file), NA)
        expect_error(res <- import_list(data_file), NA)
        expect_true(is.list(res))
        expect_equal(length(res), 3)
        expect_true(is.data.frame(res[[1]]))
        expect_true(is.data.frame(res[[2]]))
        expect_true(is.data.frame(res[[3]]))
    })
})

test_that("Using setclass in import_list()", {
    withr::with_tempfile("data_file", fileext = ".rds", code = {
        export(mtcars, data_file)
        dat1 <- import_list(rep(data_file, 2), setclass = "data.table", rbind = TRUE, trust = TRUE)
        expect_true(inherits(dat1, "data.table"))
        dat2 <- import_list(rep(data_file, 2), setclass = "tbl", rbind = TRUE, trust = TRUE)
        expect_true(inherits(dat2, "tbl"))
    })
})

test_that("Object names are preserved by import_list()", {
    withr::with_tempdir(code = {
        export(list(mtcars1 = mtcars[1:10,],
                    mtcars2 = mtcars[11:20,],
                    mtcars3 = mtcars[21:32,]), "mtcars.xlsx")
        export(list(mtcars1 = mtcars[1:10,],
                    mtcars2 = mtcars[11:20,],
                    mtcars3 = mtcars[21:32,]), "mtcars.ods")
        export(list(mtcars1 = mtcars[1:10,],
                    mtcars2 = mtcars[11:20,],
                    mtcars3 = mtcars[21:32,]), "mtcars.fods")
        export(mtcars[1:10,],  "mtcars1.csv")
        export(mtcars[11:20,], "mtcars2.tsv")
        export(mtcars[21:32,], "mtcars3.csv")
        expected_names <- c("mtcars1", "mtcars2", "mtcars3")
        dat_xls <- import_list("mtcars.xlsx")
        dat_csv <- import_list(c("mtcars1.csv","mtcars2.tsv","mtcars3.csv"))
        dat_ods <- import_list("mtcars.ods")
        dat_fods <- import_list("mtcars.fods")
        expect_identical(names(dat_xls), expected_names)
        expect_identical(names(dat_csv), expected_names)
        expect_identical(names(dat_ods), expected_names)
        expect_identical(names(dat_fods), expected_names)
    })
})

test_that("File names are added as attributes by import_list()", {
    withr::with_tempdir(code = {
        export(mtcars[1:10,],  "mtcars.csv")
        export(mtcars[11:20,], "mtcars.tsv")
        expected_names <- c("mtcars", "mtcars")
        expected_attrs <- c(mtcars = "mtcars.csv", mtcars = "mtcars.tsv")
        dat <- import_list(c("mtcars.csv","mtcars.tsv"))
        expect_identical(names(dat), expected_names)
        expect_identical(unlist(lapply(dat, attr, "filename")), expected_attrs)
    })
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
    skip_if_not_installed("readODS")
    formats <- c("ods", "fods", "xlsx", "dta", "sav", "csv", "csv2")
    for (format in formats) {
        withr::with_tempfile("tempzip", fileext = paste0(".", format, ".zip"), code = {
            rio::export(mtcars, tempzip, format = format)
            expect_warning(rio::import(tempzip), NA)
            expect_warning(rio::import_list(tempzip), NA)
        })
    }
})

test_that("Universal dummy `which` (Suggests) #326", {
    skip_if_not_installed("qs")
    skip_if_not_installed("arrow")
    skip_if_not_installed("readODS")
    skip_on_os("mac") ## apache/arrow#40991
    formats <- c("qs", "parquet", "ods")
    for (format in formats) {
        withr::with_tempfile("tempzip", fileext = paste0(".", format, ".zip"), code = {
            rio::export(mtcars, tempzip, format = format)
            expect_warning(rio::import(tempzip), NA)
            expect_warning(rio::import_list(tempzip), NA)
        })
    }
})

test_that("Informative message when files are not found #389", {
    withr::with_tempfile("mtcars_file", fileext = ".rds", code = {
        export(mtcars, mtcars_file)
        expect_true(file.exists(mtcars_file))
        expect_false(file.exists("nonexisting.rds"))
        expect_warning(import_list(c(mtcars_file, "nonexisting.rds"), trust = TRUE), "^Import failed for nonexisting")
    })
})

test_that("Missing files and rbind", {
    withr::with_tempfile("mtcars_file", fileext = ".rds", code = {
        export(mtcars, mtcars_file)
        expect_true(file.exists(mtcars_file))
        expect_false(file.exists("nonexisting.rds"))
        expect_false(file.exists("nonexisting2.rds"))
        expect_warning(x <- import_list(c(mtcars_file, "nonexisting.rds"), rbind = TRUE, trust = TRUE), "^Import failed for nonexisting")
        expect_true(is.data.frame(x))
        expect_warning(x <- import_list(c("nonexisting.rds", "nonexisting2.rds"), rbind = TRUE, trust = TRUE), "^Import failed for nonexisting")
    })
})
