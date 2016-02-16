Contributions to **rio** are welcome from anyone and are best sent as pull requests on [the GitHub repository](https://github.com/leeper/rio/). This page provides some instructions to potential contributors about how to add to the package.

 1. Contributions can be submitted as [a pull request](https://help.github.com/articles/creating-a-pull-request/) on GitHub by forking or cloning the [repo](https://github.com/leeper/rio/), making changes and submitting the pull request.
 
 2. Pull requests should involve only one commit per substantive change. This means if you change multiple files (e.g., code and documentation), these changes should be committed together. If you don't know how to do this (e.g., you are making changes in the GitHub web interface) just submit anyway and the maintainer will clean things up.
 
 3. All contributions must be submitted consistent with the package license ([GPL-2](http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)).
 
 4. All contributions need to be noted in the `Authors@R` field in the [DESCRIPTION](https://github.com/leeper/rio/blob/master/DESCRIPTION). Just follow the format of the existing entries to add your name (and, optionally, email address). Substantial contributions should also be noted in [`inst/CITATION`](https://github.com/leeper/rio/blob/master/inst/CITATION).
 
 5. This package does not use devtools or royxgen code markup. Changes to documentation need to be made manually in the appropriate Rd file. See ["Writing R Extensions"](https://cran.r-project.org/doc/manuals/r-devel/R-exts.html#Writing-R-documentation-files) if the format is unfamiliar to you.
 
 6. Please run `R CMD BUILD rio` and `R CMD CHECK rio_VERSION.tar.gz` before submitting the pull request to check for any errors.
 
Some specific types of changes that you might make are:

 1. Documentation-only changes (e.g., to Rd files, README, vignettes). This is great! All contributions are welcome.
 
 2. Addition of new file format imports or exports. This is also great! Some advice:
 
  - Import is based on S3 dispatch to functions of the form `.import.rio_FORMAT()`. Export works the same, but with `.export.rio_FORMAT()`. New import/export methods should take this form. There's no need to change the body of the `import()` or `export()` functions; S3 will take care of dispatch.
  - Any new format support needs to be documented in each of the following places: [README.Rmd](https://github.com/leeper/rio/blob/master/README.Rmd), [the vignette](https://github.com/leeper/rio/blob/master/vignettes/rio.Rmd), and the appropriate Rd file in [`/man`](https://github.com/leeper/rio/tree/master/man).
  - New formats or new options for handling formats should have a test added in [`/tests/testthat`](https://github.com/leeper/rio/tree/master/tests/testthat) called `test_format_FILETYPE.R` that completely covers the function's behavior. This may require adding an example file to [`inst/examples`](https://github.com/leeper/rio/tree/master/inst/examples) (e.g., for testing `import()`).
 
 3. Changes requiring a new package dependency should be discussed on the GitHub issues page before submitting a pull request.
 
 4. Message translations. These are very appreciated! The format is a pain, but if you're doing this I'm assuming you're already familiar with it.

Any questions you have can be opened as GitHub issues or directed to thosjleeper (at) gmail.com.

