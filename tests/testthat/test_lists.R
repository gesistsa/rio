context("Lists and Directories")
library("datasets")

test_that("Import List", {
  export(mtcars[1:8,],   "mtcars1.csv")
  export(mtcars[9:16,],  "mtcars2.csv")
  export(mtcars[17:24,], "mtcars3.csv")
  export(mtcars[25:32,], "mtcars4.csv")
  
  data_list <- import_list(c("mtcars1.csv", "mtcars2.csv", "mtcars3.csv", "mtcars4.csv"))
  data_classes <- lapply(data_list, class)
  
  expect_output(class(data_list), "list")
  expect_length(data_classes, 4)
  expect_true(all(data_classes == "data.frame"))
})

test_that("Import Directory", {
  export(mtcars[1:8,],   "mtcars1.csv")
  export(mtcars[9:16,],  "mtcars2.csv")
  export(mtcars[17:24,], "mtcars3.csv")
  export(mtcars[25:32,], "mtcars4.csv")
  
  expect_equivalent(import_directory(path = ".", file.type = ".csv"), mtcars)
})

unlink("mtcars1.csv")
unlink("mtcars2.csv")
unlink("mtcars3.csv")
unlink("mtcars4.csv")
