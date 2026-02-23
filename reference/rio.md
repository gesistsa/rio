# A Swiss-Army Knife for Data I/O

The aim of rio is to make data file input and output as easy as
possible.
[`export()`](http://gesistsa.github.io/rio/reference/export.md) and
[`import()`](http://gesistsa.github.io/rio/reference/import.md) serve as
a Swiss-army knife for painless data I/O for data from almost any file
format by inferring the data structure from the file extension, natively
reading web-based data sources, setting reasonable defaults for import
and export, and relying on efficient data import and export packages. An
additional convenience function,
[`convert()`](http://gesistsa.github.io/rio/reference/convert.md),
provides a simple method for converting between file types.

Note that some of rio's functionality is provided by ‘Suggests’
dependendencies, meaning they are not installed by default. Use
[`install_formats()`](http://gesistsa.github.io/rio/reference/install_formats.md)
to make sure these packages are available for use.

## References

[datamods](https://cran.r-project.org/package=datamods) provides Shiny
modules for importing data via `rio`.

[GREA](https://github.com/Stan125/GREA) provides an RStudio add-in to
import data using rio.

## See also

[`import()`](http://gesistsa.github.io/rio/reference/import.md),
[`import_list()`](http://gesistsa.github.io/rio/reference/import_list.md),
[`export()`](http://gesistsa.github.io/rio/reference/export.md),
[`export_list()`](http://gesistsa.github.io/rio/reference/export_list.md),
[`convert()`](http://gesistsa.github.io/rio/reference/convert.md),
[`install_formats()`](http://gesistsa.github.io/rio/reference/install_formats.md)

## Author

**Maintainer**: Chung-hong Chan <chainsawtiney@gmail.com>
([ORCID](https://orcid.org/0000-0002-6232-7530))

Authors:

- Jason Becker <jason@jbecker.co>

- David Schoch <david@schochastics.net>
  ([ORCID](https://orcid.org/0000-0003-2952-4812))

- Thomas J. Leeper <thosjleeper@gmail.com>
  ([ORCID](https://orcid.org/0000-0003-4097-6326))

Other contributors:

- Geoffrey CH Chan <gefchchan@gmail.com> \[contributor\]

- Christopher Gandrud \[contributor\]

- Andrew MacDonald \[contributor\]

- Ista Zahn \[contributor\]

- Stanislaus Stadlmann \[contributor\]

- Ruaridh Williamson <ruaridh.williamson@gmail.com> \[contributor\]

- Patrick Kennedy \[contributor\]

- Ryan Price <ryapric@gmail.com> \[contributor\]

- Trevor L Davis <trevor.l.davis@gmail.com> \[contributor\]

- Nathan Day <nathancday@gmail.com> \[contributor\]

- Bill Denney <wdenney@humanpredictions.com>
  ([ORCID](https://orcid.org/0000-0002-5759-428X)) \[contributor\]

- Alex Bokov <alex.bokov@gmail.com>
  ([ORCID](https://orcid.org/0000-0002-0511-9815)) \[contributor\]

- Hugo Gruson ([ORCID](https://orcid.org/0000-0002-4094-1476))
  \[contributor\]

- Jacob Mears \[contributor\]

## Examples

``` r
# export
library("datasets")
export(mtcars, csv_file <- tempfile(fileext = ".csv")) # comma-separated values
export(mtcars, rds_file <- tempfile(fileext = ".rds")) # R serialized
export(mtcars, sav_file <- tempfile(fileext = ".sav")) # SPSS

# import
x <- import(csv_file)
y <- import(rds_file)
#> Warning: Missing `trust` will be set to FALSE by default for RDS in 2.0.0.
z <- import(sav_file)

# convert sav (SPSS) to dta (Stata)
convert(sav_file, dta_file <- tempfile(fileext = ".dta"))

# cleanup
unlink(c(csv_file, rds_file, sav_file, dta_file))
```
