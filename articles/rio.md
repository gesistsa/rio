# Import, Export, and Convert Data Files

## Import, Export, and Convert Data Files

The idea behind **rio** is to simplify the process of importing data
into R and exporting data from R. This process is, probably
unnecessarily, extremely complex for beginning R users. Indeed, R
supplies [an entire
manual](https://cran.r-project.org/doc/manuals/r-release/R-data.html)
describing the process of data import/export. And, despite all of that
text, most of the packages described are (to varying degrees)
out-of-date. Faster, simpler, packages with fewer dependencies have been
created for many of the file types described in that document. **rio**
aims to unify data I/O (importing and exporting) into two simple
functions:
[`import()`](http://gesistsa.github.io/rio/reference/import.md) and
[`export()`](http://gesistsa.github.io/rio/reference/export.md) so that
beginners (and experienced R users) never have to think twice (or even
once) about the best way to read and write R data.

The core advantage of **rio** is that it makes assumptions that the user
is probably willing to make. Specifically, **rio** uses the file
extension of a file name to determine what kind of file it is. This is
the same logic used by Windows OS, for example, in determining what
application is associated with a given file type. By taking away the
need to manually match a file type (which a beginner may not recognize)
to a particular import or export function, **rio** allows almost all
common data formats to be read with the same function.

By making import and export easy, it’s an obvious next step to also use
R as a simple data conversion utility. Transferring data files between
various proprietary formats is always a pain and often expensive. The
`convert` function therefore combines `import` and `export` to easily
convert between file formats (thus providing a FOSS replacement for
programs like Stat/Transfer or Sledgehammer.

### Supported file formats

**rio** supports a variety of different file formats for import and
export. To keep the package slim, all non-essential formats are
supported via “Suggests” packages, which are not installed (or loaded)
by default. To ensure rio is fully functional, install these packages
the first time you use **rio** via:

``` r
install_formats()
```

The full list of supported formats is below:

| Name                                | Extensions / “format”               | Import Package | Export Package | Type    | Note                           |
|:------------------------------------|:------------------------------------|:---------------|:---------------|:--------|:-------------------------------|
| Archive files (handled by tar)      | tar / tar.gz / tgz / tar.bz2 / tbz2 | utils          | utils          | Default |                                |
| Bzip2                               | bz2 / bzip2                         | base           | base           | Default |                                |
| Gzip                                | gz / gzip                           | base           | base           | Default |                                |
| Zip files                           | zip                                 | utils          | utils          | Default |                                |
| Ambiguous file format               | dat                                 | data.table     |                | Default | Attempt as delimited text data |
| CSVY (CSV + YAML metadata header)   | csvy                                | data.table     | data.table     | Default |                                |
| Comma-separated data                | csv                                 | data.table     | data.table     | Default |                                |
| Comma-separated data (European)     | csv2                                | data.table     | data.table     | Default |                                |
| Data Interchange Format             | dif                                 | utils          |                | Default |                                |
| Epiinfo                             | epiinfo / rec                       | foreign        |                | Default |                                |
| Excel                               | excel / xlsx                        | readxl         | writexl        | Default |                                |
| Excel (Legacy)                      | xls                                 | readxl         |                | Default |                                |
| Excel (Read only)                   | xlsm / xltx / xltm                  | readxl         |                | Default |                                |
| Fixed-width format data             | fwf                                 | readr          | utils          | Default |                                |
| Fortran data                        | fortran                             | utils          |                | Default | No recognized extension        |
| Google Sheets                       | googlesheets                        | data.table     |                | Default | As comma-separated data        |
| Minitab                             | minitab / mtp                       | foreign        |                | Default |                                |
| Pipe-separated data                 | psv                                 | data.table     | data.table     | Default |                                |
| R syntax                            | r                                   | base           | base           | Default |                                |
| SAS                                 | sas / sas7bdat                      | haven          | haven          | Default | Export is deprecated           |
| SAS XPORT                           | xport / xpt                         | haven          | haven          | Default |                                |
| SPSS                                | sav / spss                          | haven          | haven          | Default |                                |
| SPSS (compressed)                   | zsav                                | haven          | haven          | Default |                                |
| SPSS Portable                       | por                                 | haven          |                | Default |                                |
| Saved R objects                     | rda / rdata                         | base           | base           | Default |                                |
| Serialized R objects                | rds                                 | base           | base           | Default |                                |
| Stata                               | dta / stata                         | haven          | haven          | Default |                                |
| Systat                              | syd / systat                        | foreign        |                | Default |                                |
| Tab-separated data                  | / tsv / txt                         | data.table     | data.table     | Default |                                |
| Text Representations of R Objects   | dump                                | base           | base           | Default |                                |
| Weka Attribute-Relation File Format | arff / weka                         | foreign        | foreign        | Default |                                |
| XBASE database files                | dbf                                 | foreign        | foreign        | Default |                                |
| Apache Arrow (Parquet)              | parquet                             | nanoparquet    | nanoparquet    | Suggest |                                |
| Clipboard                           | clipboard                           | clipr          | clipr          | Suggest | default is tsv                 |
| EViews                              | eviews / wf1                        | hexView        |                | Suggest |                                |
| Fast Storage                        | fst                                 | fst            | fst            | Suggest |                                |
| Feather R/Python interchange format | feather                             | arrow          | arrow          | Suggest |                                |
| Graphpad Prism                      | pzfx                                | pzfx           | pzfx           | Suggest |                                |
| HTML Tables                         | htm / html                          | xml2           | xml2           | Suggest |                                |
| JSON                                | json                                | jsonlite       | jsonlite       | Suggest |                                |
| Matlab                              | mat / matlab                        | rmatio         | rmatio         | Suggest |                                |
| OpenDocument Spreadsheet            | ods                                 | readODS        | readODS        | Suggest |                                |
| OpenDocument Spreadsheet (Flat)     | fods                                | readODS        | readODS        | Suggest |                                |
| Serialized R objects (qs2)          | qs2                                 | qs2            | qs2            | Suggest |                                |
| Shallow XML documents               | xml                                 | xml2           | xml2           | Suggest |                                |
| YAML                                | yaml / yml                          | yaml           | yaml           | Suggest |                                |

Additionally, any format that is not supported by **rio** but that has a
known R implementation will produce an informative error message
pointing to a package and import or export function. Unrecognized
formats will yield a simple “Unrecognized file format” error.

### Data Import

**rio** allows you to import files in almost any format using one,
typically single-argument, function.
[`import()`](http://gesistsa.github.io/rio/reference/import.md) infers
the file format from the file’s extension and calls the appropriate data
import function for you, returning a simple data.frame. This works for
any for the formats listed above.

``` r
library("rio")

x <- import("mtcars.csv")
y <- import("mtcars.dta")

# confirm identical
all.equal(x, y, check.attributes = FALSE)
```

    ## [1] TRUE

If for some reason a file does not have an extension, or has a file
extension that does not match its actual type, you can manually specify
a file format to override the format inference step. For example, we can
read in a CSV file that does not have a file extension by specifying
`csv`:

``` r
head(import("mtcars_noext", format = "csv"))
```

    ##    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## 1 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## 2 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## 3 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## 4 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## 5 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## 6 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

#### Importing Data Lists

Sometimes you may have multiple data files that you want to import.
[`import()`](http://gesistsa.github.io/rio/reference/import.md) only
ever returns a single data frame, but
[`import_list()`](http://gesistsa.github.io/rio/reference/import_list.md)
can be used to import a vector of file names into R. This works even if
the files are different formats:

``` r
str(import_list(dir()), 1)
```

Similarly, some single-file formats (e.g. Excel Workbooks, Zip
directories, HTML files, etc.) can contain multiple data sets. Because
[`import()`](http://gesistsa.github.io/rio/reference/import.md) is type
safe, always returning a data frame, importing from these formats
requires specifying a `which` argument to
[`import()`](http://gesistsa.github.io/rio/reference/import.md) to
dictate which data set (worksheet, file, table, etc.) to import (the
default being `which = 1`). But
[`import_list()`](http://gesistsa.github.io/rio/reference/import_list.md)
can be used to import all (or only a specified subset, again via
`which`) of data objects from these types of files.

### Data Export

The export capabilities of **rio** are somewhat more limited than the
import capabilities, given the availability of different functions in
various R packages and because import functions are often written to
make use of data from other applications and it never seems to be a
development priority to have functions to export to the formats used by
other applications. That said, **rio** currently supports the following
formats:

``` r
library("rio")

export(mtcars, "mtcars.csv")
export(mtcars, "mtcars.dta")
```

It is also easy to use
[`export()`](http://gesistsa.github.io/rio/reference/export.md) as part
of an R pipeline (from magrittr or dplyr). For example, the following
code uses
[`export()`](http://gesistsa.github.io/rio/reference/export.md) to save
the results of a simple data transformation:

``` r
library("magrittr")
mtcars %>%
  subset(hp > 100) %>%
  aggregate(. ~ cyl + am, data = ., FUN = mean) %>%
  export(file = "mtcars2.dta")
```

Some file formats (e.g., Excel workbooks, Rdata files) can support
multiple data objects in a single file.
[`export()`](http://gesistsa.github.io/rio/reference/export.md) natively
supports output of multiple objects to these types of files:

``` r
# export to sheets of an Excel workbook
export(list(mtcars = mtcars, iris = iris), "multi.xlsx")
```

It is also possible to use the new (as of v0.6.0) function
[`export_list()`](http://gesistsa.github.io/rio/reference/export_list.md)
to write a list of data frames to multiple files using either a vector
of file names or a file pattern:

``` r
export_list(list(mtcars = mtcars, iris = iris), "%s.tsv")
```

### File Conversion

The [`convert()`](http://gesistsa.github.io/rio/reference/convert.md)
function links
[`import()`](http://gesistsa.github.io/rio/reference/import.md) and
[`export()`](http://gesistsa.github.io/rio/reference/export.md) by
constructing a dataframe from the imported file and immediately writing
it back to disk.
[`convert()`](http://gesistsa.github.io/rio/reference/convert.md)
invisibly returns the file name of the exported file, so that it can be
used to programmatically access the new file.

Because
[`convert()`](http://gesistsa.github.io/rio/reference/convert.md) is
just a thin wrapper for
[`import()`](http://gesistsa.github.io/rio/reference/import.md) and
[`export()`](http://gesistsa.github.io/rio/reference/export.md), it is
very easy to use. For example, we can convert

``` r
# create file to convert
export(mtcars, "mtcars.dta")

# convert Stata to SPSS
convert("mtcars.dta", "mtcars.sav")
```

[`convert()`](http://gesistsa.github.io/rio/reference/convert.md) also
accepts lists of arguments for controlling import (`in_opts`) and export
(`out_opts`). This can be useful for passing additional arguments to
import or export methods. This could be useful, for example, for reading
in a fixed-width format file and converting it to a comma-separated
values file:

``` r
# create an ambiguous file
fwf <- tempfile(fileext = ".fwf")
cat(file = fwf, "123456", "987654", sep = "\n")

# see two ways to read in the file
identical(import(fwf, widths = c(1, 2, 3)), import(fwf, widths = c(1, -2, 3)))
```

    ## Warning: The `widths` argument of `import()` is deprecated as of rio 1.0.2.
    ## ℹ `widths` is kept for backward compatibility. Please use `col_positions` or
    ##   unset `widths` to allow automatic guessing, see `?readr::read_fwf`. The
    ##   parameter `widths` will be dropped in v2.0.0.
    ## ℹ The deprecated feature was likely used in the rio package.
    ##   Please report the issue at <https://github.com/gesistsa/rio/issues>.
    ## This warning is displayed once per session.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

    ## Rows: 2 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## 
    ## dbl (3): X1, X2, X3
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 2 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## 
    ## dbl (3): X1, X2, X3
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## [1] FALSE

``` r
# convert to CSV
convert(fwf, "fwf.csv", in_opts = list(widths = c(1, 2, 3)))
```

    ## Rows: 2 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## 
    ## dbl (3): X1, X2, X3
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
import("fwf.csv") # check conversion
```

    ##   X1 X2  X3
    ## 1  1 23 456
    ## 2  9 87 654

With metadata-rich file formats (e.g., Stata, SPSS, SAS), it can also be
useful to pass imported data through
[`characterize()`](http://gesistsa.github.io/rio/reference/characterize.md)
or
[`factorize()`](http://gesistsa.github.io/rio/reference/characterize.md)
when converting to an open, text-delimited format:
[`characterize()`](http://gesistsa.github.io/rio/reference/characterize.md)
converts a single variable or all variables in a data frame that have
“labels” attributes into character vectors based on the mapping of
values to value labels (e.g.,
`export(characterize(import("file.dta")), "file.csv")`). An alternative
approach is exporting to CSVY format, which records metadata in a
YAML-formatted header at the beginning of a CSV file.

It is also possible to use **rio** on the command-line by calling
`Rscript` with the `-e` (expression) argument. For example, to convert a
file from Stata (.dta) to comma-separated values (.csv), simply do the
following:

    Rscript -e "rio::convert('mtcars.dta', 'mtcars.csv')"
