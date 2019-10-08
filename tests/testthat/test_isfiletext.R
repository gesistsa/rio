context("correctly identifying files as text vs binary")
require("datasets")

txtformats <- c("arff","csv","csv2","dump","fwf","psv","r","tsv","txt","fwf")
binformats <- c("dbf","dta","rda","rdata","rds","sas7bdat","sav","xlsx","xpt")
names(iris) <- gsub("\\.","_",names(iris))

test_that("Required text formats recognized as text", {
  for(xx in txtformats) expect_true(isfiletext(export(iris,
                                                      paste0("iris.",xx))),
                                    label = paste0(xx," should be text"))
  })

test_that("Required non-text formats recognized as non-text", {
  for(xx in binformats) expect_false(isfiletext(export(iris,
                                                       paste0("iris.",xx))),
                                     label = paste0(xx," should be text"))
  })

test_that("csvy recognized as text", {
  skip_if_not_installed(pkg="csvy")
  expect_true(isfiletext(export(iris,'iris.csvy')))
  })

test_that("xml and html recognized as text", {
  skip_if_not_installed(pkg="xml2")
  expect_true(isfiletext(export(iris,'iris.xml')))
  expect_true(isfiletext(export(iris,'iris.html')))
  })

test_that("json recognized as text", {
  skip_if_not_installed(pkg="jsonlite")
  expect_true(isfiletext(export(iris,'iris.json')))
  })

test_that("yml recognized as text", {
  skip_if_not_installed(pkg="yaml")
  expect_true(isfiletext(export(iris,'iris.yml')))
  })

test_that("pzfx recognized as text", {
  skip_if_not_installed(pkg="pzfx")
  expect_true(isfiletext(export(iris[,-5],"iris.pzfx")))
  })

# binformats_suggest <- c("matlab","ods","fst","feather")
test_that("matlab recognized as binary", {
  skip_if_not_installed(pkg="rmatio")
  expect_false(isfiletext(export(iris,'iris.matlab')))
})

test_that("ods recognized as binary", {
  skip_if_not_installed(pkg="readODS")
  expect_false(isfiletext(export(iris,'iris.ods')))
})

test_that("fst recognized as binary", {
  skip_if_not_installed(pkg="fst")
  expect_false(isfiletext(export(iris,'iris.fst')))
})

test_that("feather recognized as binary", {
  skip_if_not_installed(pkg="feather")
  expect_false(isfiletext(export(iris,'iris.feather')))
})

unlink(paste0('iris.',c(txtformats,binformats,'csvy','xml','html','json',
                        'yml','pzfx','matlab','ods',
                        'fst','feather')))
rm(iris,txtformats,binformats)

