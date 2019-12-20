context("Reconcile user-supplied arguments with target function's call signature")
require("datasets")
require("tools")
require("tibble")

sharedargs <- alist(file = "iris.tsv", x = iris, sep = "\t", 
                    fileEncoding = "UTF-8", showProgress = FALSE, skip = 2, 
                    n_max = 4, stringsAsFactors = TRUE)

fwrite_args0 <- alist(file = "iris.tsv", x = iris, sep = "\t", 
                      showProgress = FALSE)
writetable_args0 <- alist(file = "iris.tsv", x = iris, sep = "\t", 
                          fileEncoding = "UTF-8")
dta_args0 <- alist(data = iris, path = "iris.dta")
sav_args0 <- alist(data = iris, path = "iris.sav")
iris <- setNames(iris, sub(".", "", names(iris), fixed = TRUE))
export(iris, "iris_ref.tsv")
export(iris, "iris_ref.dta")
export(iris, "iris_ref.sav")

test_that("hardcoded reference arguments are valid", {
  expect_silent(do.call(data.table::fwrite, fwrite_args0))
  expect_silent(do.call(haven::write_dta, dta_args0))
})

test_that("warn on mismatched args and filter them out", {
  expect_warning(arg_reconcile(data.table::fwrite, file = "iris.tsv", x = iris, 
                               sep = "\t", fileEncoding = "UTF-8", 
                               showProgress = FALSE, skip = 2, n_max = 4), 
                 "fileEncoding")
  expect_warning(arg_reconcile(utils::write.table, file = "iris.tsv", x = iris, 
                               sep = "\t", fileEncoding = "UTF-8", 
                               showProgress = FALSE, skip = 2, n_max = 4), 
                 "showProgress")
  expect_warning(arg_reconcile(data.table::fwrite, .args = sharedargs), 
                 "fileEncoding")
  expect_warning(arg_reconcile(utils::write.table, .args = sharedargs), 
                 "showProgress")
})

test_that("valid outputs with suppressed warnings", {
  expect_silent(fwrite_args1 <- arg_reconcile(data.table::fwrite, 
                                              file = "iris.tsv", 
                                              x = iris, sep = "\t", 
                                              fileEncoding = "UTF-8", 
                                              showProgress = FALSE, 
                                              skip = 2, n_max = 4, 
                                              .warn = FALSE))
  expect_identical(fwrite_args0, fwrite_args1)
  expect_silent(writetable_args1 <- arg_reconcile(utils::write.table, 
                                                  file = "iris.tsv", x = iris, 
                                                  sep = "\t", 
                                                  fileEncoding = "UTF-8", 
                                                  showProgress = FALSE, 
                                                  skip = 2, n_max = 4, 
                                                  .warn = FALSE))
  expect_identical(writetable_args0, writetable_args1)
  expect_silent(fwrite_args1 <- arg_reconcile(data.table::fwrite, .args = sharedargs, 
                                              .warn = FALSE))
  expect_identical(fwrite_args0, fwrite_args1)
  expect_silent(writetable_args1 <- arg_reconcile(utils::write.table, 
                                                  .args = sharedargs, 
                                                  .warn = FALSE))
  expect_identical(writetable_args0, writetable_args1)
})

test_that(".remap argument remaps argument names", {
  expect_warning(dta_args1 <- arg_reconcile(haven::write_dta, file = "iris.dta", 
                                            x = iris, sep= "\t", 
                                            fileEncoding = "UTF-8", 
                                            showProgress = FALSE, skip = 2, 
                                            n_max = 4, 
                                            .remap = list(x = "data", 
                                                          file = "path")) 
                 ,"sep")
  expect_identical(dta_args0, dta_args1)
  expect_warning(sav_args1 <- arg_reconcile(haven::write_sav, file = "iris.sav", 
                                            x = iris, sep = "\t", 
                                            fileEncoding = "UTF-8", 
                                            showProgress = FALSE, skip = 2, 
                                            n_max = 4,
                                            .remap = list(x = "data", 
                                                          file = "path")) 
                 ,"sep")
  expect_identical(sav_args0, sav_args1)
  expect_warning(dta_args1 <- arg_reconcile(haven::write_dta, file = "iris.dta", 
                                            .args = sharedargs, 
                                            .remap = list(x = "data", 
                                                          file = "path")), 
                 "sep")
  expect_identical(dta_args0, dta_args1)
  expect_warning(sav_args1 <- arg_reconcile(haven::write_sav, file = "iris.sav", 
                                            .args = sharedargs, 
                                            .remap = list(x = "data", 
                                                          file = "path")), 
                 "sep")
  expect_identical(sav_args0, sav_args1)
})

test_that(".docall works", {
  expect_equivalent(iris[1:4,], arg_reconcile(data.table::fread, 
                                              file = "iris_ref.tsv", 
                                              .warn = FALSE, .args = sharedargs, 
                                              .docall = TRUE, .bklist = 'skip', 
                                              .remap = list(n_max = "nrows")))
  expect_equivalent(iris[1:4,], arg_reconcile(utils::read.table, 
                                              file = "iris_ref.tsv", 
                                              .warn = FALSE, .args = sharedargs, 
                                              .docall = TRUE, .bklist = 'skip', 
                                              header = TRUE, 
                                              .remap = list(n_max = "nrows")))
  expect_equivalent(iris[3:6,1:4], arg_reconcile(haven::read_dta, 
                                                 file = "iris_ref.dta", 
                                                 .warn = FALSE, 
                                                 .args = sharedargs, 
                                                 .docall = TRUE)[,1:4])
  expect_equivalent(iris[3:6,1:4], arg_reconcile(haven::read_sav, 
                                                 file = "iris_ref.sav", 
                                                 .warn = FALSE, 
                                                 .args = sharedargs, 
                                                 .docall = TRUE)[,1:4])
})

# TODO: .docall produces results identical to corresponding direct invokation
# TODO: do.call on *_args0 produces results identical to corresponding direct invokation

# cleanup
unlink(c("iris_ref.*","iris.tsv","iris.dat","iris.sav"))
