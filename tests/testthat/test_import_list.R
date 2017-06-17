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
    dat <- import_list(system.file("examples", "twotables.html", package = "rio"))
    expect_true(identical(dim(dat[[1]]), dim(mtcars)))
    expect_true(identical(names(dat[[1]]), names(mtcars)))
    expect_true(identical(dim(dat[[2]]), dim(iris)))
    expect_true(identical(names(dat[[2]]), names(iris)))
})

test_that("Import single file via import_list()", {
    expect_true(identical(import_list("mtcars.rds", rbind = TRUE), mtcars))
})

test_that("Using setclass in import_list()", {
    dat1 <- import_list(rep("mtcars.rds", 2), setclass = "data.table", rbind = TRUE)
    expect_true(inherits(dat1, "data.table"))
    dat2 <- import_list(rep("mtcars.rds", 2), setclass = "tbl", rbind = TRUE)
    expect_true(inherits(dat2, "tbl"))
    expect_warning(dat3 <- import_list(rep("mtcars.rds", 2), setclass = "data.frame", rbind = TRUE, data.table = TRUE))
    expect_true(inherits(dat3, "data.frame"))
    
})

unlink("data.rdata")
unlink("mtcars.rds")
