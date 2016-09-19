# context("custom s3 methods import and export")
# require("datasets")
# 
# test_that("Custom imports with supplied formats work", {
#   .import.rio_customimport <- function(filename){
#     read.csv(filename)
#   }
#   write.csv(iris, 'iris.customimport')
#   expect_true(is.data.frame(import('iris.customimport', format = 'customimport')))
#   unlink("iris.customimport")
# })