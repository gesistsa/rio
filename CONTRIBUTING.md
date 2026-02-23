# NA

Contributions to **rio** are welcome from anyone and are best sent as
pull requests on [the GitHub
repository](https://github.com/gesistsa/rio/). This page provides some
instructions to potential contributors about how to add to the package.

1.  Contributions can be submitted as [a pull
    request](https://help.github.com/articles/creating-a-pull-request/)
    on GitHub by forking or cloning the
    [repo](https://github.com/gesistsa/rio/), making changes and
    submitting the pull request.

2.  Pull requests should involve only one commit per substantive change.
    This means if you change multiple files (e.g., code and
    documentation), these changes should be committed together. If you
    don’t know how to do this (e.g., you are making changes in the
    GitHub web interface) just submit anyway and the maintainer will
    clean things up.

3.  All contributions must be submitted consistent with the package
    license
    ([GPL-2](http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.md)).

4.  All contributions need to be noted in the `Authors@R` field in the
    [DESCRIPTION](https://github.com/gesistsa/rio/blob/master/DESCRIPTION).
    Just follow the format of the existing entries to add your name
    (and, optionally, email address). Substantial contributions should
    also be noted in
    [`inst/CITATION`](https://github.com/gesistsa/rio/blob/master/inst/CITATION).

5.  This package uses royxgen code and documentation markup, so changes
    should be made to roxygen comments in the source code `.R` files. If
    changes are made, roxygen needs to be run. The easiest way to do
    this is a command line call to: `Rscript -e devtools::document()`.
    Please resolve any roxygen errors before submitting a pull request.

6.  Please run `R CMD BUILD rio` and `R CMD CHECK rio_VERSION.tar.gz`
    before submitting the pull request to check for any errors.

Some specific types of changes that you might make are:

1.  Documentation-only changes (e.g., to Rd files, README, vignettes).
    This is great! All contributions are welcome.

2.  Addition of new file format imports or exports. This is also great!
    Some advice:

- Import is based on S3 dispatch to functions of the form
  `.import.rio_FORMAT()`. Export works the same, but with
  `.export.rio_FORMAT()`. New import/export methods should take this
  form. There’s no need to change the body of the
  [`import()`](http://gesistsa.github.io/rio/reference/import.md) or
  [`export()`](http://gesistsa.github.io/rio/reference/export.md)
  functions; S3 will take care of dispatch. All `.import()` methods must
  accept a `file` and `which` argument: `file` represents the path to
  the file and `which` can be used to extract sheets or files from
  multi-object files (e.g., zip, Excel workbooks, etc.). `.export()`
  methods take two arguments: `file` and `x`, where `file` is the path
  to the file and `x` is the data frame being exported. Most of the work
  of import and export methods involves mapping these arguments to their
  corresponding argument names in the various underlying packages. See
  the Vignette: `remap`.

- The S3 methods should be documented in
  [NAMESPACE](https://github.com/gesistsa/rio/blob/master/NAMESPACE)
  using `S3method()`, which is handled automatically by roxygen markup
  in the source code.

- Any new format support needs to be documented in each of the following
  places:
  [README.Rmd](https://github.com/gesistsa/rio/blob/master/README.Rmd),
  [the
  vignette](https://github.com/gesistsa/rio/blob/master/vignettes/rio.Rmd),
  and the appropriate Rd file in
  [`/man`](https://github.com/gesistsa/rio/tree/master/man).

- New formats or new options for handling formats should have a test
  added in
  [`/tests/testthat`](https://github.com/gesistsa/rio/tree/master/tests/testthat)
  called `test_format_FORMAT.R` that completely covers the function’s
  behavior. This may require adding an example file to
  [`inst/examples`](https://github.com/gesistsa/rio/tree/master/inst/examples)
  (e.g., for testing
  [`import()`](http://gesistsa.github.io/rio/reference/import.md)).

3.  Changes requiring a new package dependency should be discussed on
    the GitHub issues page before submitting a pull request.

4.  Message translations. These are very appreciated! The format is a
    pain, but if you’re doing this I’m assuming you’re already familiar
    with it.

Any questions you have can be opened as GitHub issues.
