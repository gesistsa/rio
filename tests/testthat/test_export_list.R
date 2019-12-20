context("Test export_list()")
library("datasets")

export(list(mtcars3 = mtcars[1:10,], 
            mtcars2 = mtcars[11:20,],
            mtcars1 = mtcars[21:32,]), "mtcars.xlsx")
mylist <- import_list("mtcars.xlsx")

test_that("export_list() works", {
    expect_true(identical(export_list(mylist, file = paste0("mtcars_", 3:1, ".csv")), paste0("mtcars_", 3:1, ".csv")))
    expect_true(identical(export_list(mylist, file = "%s.csv"), paste0("mtcars", 3:1, ".csv")))

    expect_true(all.equal(mylist[["mtcars1"]], import("mtcars1.csv")))
    expect_true(all.equal(mylist[["mtcars2"]], import("mtcars2.csv")))
    expect_true(all.equal(mylist[["mtcars3"]], import("mtcars3.csv")))

    names(mylist) <- NULL
    expect_true(identical(export_list(mylist, file = "mtcars_%s.csv"), paste0("mtcars_", 1:3, ".csv")))

    names(mylist) <- c("a", "", "c")
    expect_error(export_list(mylist), label = "export_list() fails without 'file' argument")
    expect_error(export_list(mylist, file = c("a.csv", "b.csv")), label = "export_list() fails with mismatched argument lengths")

    names(mylist) <- c("a", "a", "c")
    expect_error(export_list(mylist, file = "mtcars_%s.csv"), label = "export_list() fails with duplicated data frame names")
    
})

unlink("mtcars.xlsx")
unlink("mtcars1.csv")
unlink("mtcars2.csv")
unlink("mtcars3.csv")
unlink("mtcars_1.csv")
unlink("mtcars_2.csv")
unlink("mtcars_3.csv")

unlink("a.csv")
unlink("b.csv")
