
# rio: A Swiss-Army Knife for Data I/O <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
Version](https://www.r-pkg.org/badges/version/rio)](https://cran.r-project.org/package=rio)
![Downloads](https://cranlogs.r-pkg.org/badges/rio) <!-- badges: end -->

## Overview

The aim of **rio** is to make data file I/O in R as easy as possible by
implementing two main functions in Swiss-army knife style:

  - `import()` provides a painless data import experience by
    automatically choosing the appropriate import/read function based on
    file extension (or a specified `format` argument)
  - `export()` provides the same painless file recognition for data
    export/write functionality

## Installation

The package is available on
[CRAN](https://cran.r-project.org/package=rio) and can be installed
directly in R using `install.packages()`.

``` r
install.packages("rio")
```

The latest development version on GitHub can be installed using:

``` r
if (!require("remotes")){
    install.packages("remotes")
}
remotes::install_github("chainsawriot/rio")
```

Optional: Installation of additional formats (see below: **Supported
file formats**)

``` r
library(rio)
install_formats()
```

## Usage

Because **rio** is meant to streamline data I/O, the package is
extremely easy to use. Here are some examples of reading, writing, and
converting data files.

### Import

Importing data is handled with one function, `import()`:

``` r
library("rio")
import("starwars.xlsx")
```

    ##                  Name homeworld species
    ## 1      Luke Skywalker  Tatooine   Human
    ## 2               C-3PO  Tatooine   Human
    ## 3               R2-D2  Alderaan   Human
    ## 4         Darth Vader  Tatooine   Human
    ## 5         Leia Organa  Tatooine   Human
    ## 6           Owen Lars  Tatooine   Human
    ## 7  Beru Whitesun lars   Stewjon   Human
    ## 8               R5-D4  Tatooine   Human
    ## 9   Biggs Darklighter  Kashyyyk Wookiee
    ## 10     Obi-Wan Kenobi  Corellia   Human

``` r
import("starwars.csv")
```

    ##                  Name homeworld species
    ## 1      Luke Skywalker  Tatooine   Human
    ## 2               C-3PO  Tatooine   Human
    ## 3               R2-D2  Alderaan   Human
    ## 4         Darth Vader  Tatooine   Human
    ## 5         Leia Organa  Tatooine   Human
    ## 6           Owen Lars  Tatooine   Human
    ## 7  Beru Whitesun lars   Stewjon   Human
    ## 8               R5-D4  Tatooine   Human
    ## 9   Biggs Darklighter  Kashyyyk Wookiee
    ## 10     Obi-Wan Kenobi  Corellia   Human

Note: Because of inconsistencies across underlying packages, the
data.frame returned by `import` might vary slightly (in variable classes
and attributes) depending on file type.

### Export

Exporting data is handled with one function, `export()`:

``` r
export(mtcars, "mtcars.csv") # comma-separated values
export(mtcars, "mtcars.rds") # R serialized
export(mtcars, "mtcars.sav") # SPSS
```

A particularly useful feature of rio is the ability to import from and
export to compressed (e.g., zip) directories, saving users the extra
step of compressing a large exported file, e.g.:

``` r
export(mtcars, "mtcars.tsv.zip")
```

`export()` can also write multiple data frames to respective sheets of
an Excel workbook or an HTML file:

``` r
export(list(mtcars = mtcars, iris = iris), file = "mtcars.xlsx")
```

## Supported file formats

**rio** supports a wide range of file formats. To keep the package slim,
several formats are supported via “Suggests” packages, which are not
installed (or loaded) by default. To ensure rio is fully functional,
install these packages the first time you use **rio** via:

``` r
install_formats()
```

The full list of supported formats is below:

| Format                                                | Typical Extension       | Import Package                                                  | Export Package                                                                                                          | Installed by Default |
| ----------------------------------------------------- | ----------------------- | --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | -------------------- |
| Comma-separated data                                  | .csv                    | [**data.table**](https://cran.r-project.org/package=data.table) | [**data.table**](https://cran.r-project.org/package=data.table)                                                         | Yes                  |
| Pipe-separated data                                   | .psv                    | [**data.table**](https://cran.r-project.org/package=data.table) | [**data.table**](https://cran.r-project.org/package=data.table)                                                         | Yes                  |
| Tab-separated data                                    | .tsv                    | [**data.table**](https://cran.r-project.org/package=data.table) | [**data.table**](https://cran.r-project.org/package=data.table)                                                         | Yes                  |
| CSVY (CSV + YAML metadata header)                     | .csvy                   | [**data.table**](https://cran.r-project.org/package=data.table) | [**data.table**](https://cran.r-project.org/package=data.table)                                                         | Yes                  |
| SAS                                                   | .sas7bdat               | [**haven**](https://cran.r-project.org/package=haven)           | [**haven**](https://cran.r-project.org/package=haven) (but [deprecated](https://github.com/tidyverse/haven/issues/224)) | Yes                  |
| SPSS                                                  | .sav                    | [**haven**](https://cran.r-project.org/package=haven)           | [**haven**](https://cran.r-project.org/package=haven)                                                                   | Yes                  |
| SPSS (compressed)                                     | .zsav                   | [**haven**](https://cran.r-project.org/package=haven)           | [**haven**](https://cran.r-project.org/package=haven)                                                                   | Yes                  |
| Stata                                                 | .dta                    | [**haven**](https://cran.r-project.org/package=haven)           | [**haven**](https://cran.r-project.org/package=haven)                                                                   | Yes                  |
| SAS XPORT                                             | .xpt                    | [**haven**](https://cran.r-project.org/package=haven)           | [**haven**](https://cran.r-project.org/package=haven)                                                                   | Yes                  |
| SPSS Portable                                         | .por                    | [**haven**](https://cran.r-project.org/package=haven)           |                                                                                                                         | Yes                  |
| Excel                                                 | .xls                    | [**readxl**](https://cran.r-project.org/package=readxl)         |                                                                                                                         | Yes                  |
| Excel                                                 | .xlsx                   | [**readxl**](https://cran.r-project.org/package=readxl)         | [**openxlsx**](https://cran.r-project.org/package=openxlsx)                                                             | Yes                  |
| R syntax                                              | .R                      | **base**                                                        | **base**                                                                                                                | Yes                  |
| Saved R objects                                       | .RData, .rda            | **base**                                                        | **base**                                                                                                                | Yes                  |
| Serialized R objects                                  | .rds                    | **base**                                                        | **base**                                                                                                                | Yes                  |
| Epiinfo                                               | .rec                    | [**foreign**](https://cran.r-project.org/package=foreign)       |                                                                                                                         | Yes                  |
| Minitab                                               | .mtp                    | [**foreign**](https://cran.r-project.org/package=foreign)       |                                                                                                                         | Yes                  |
| Systat                                                | .syd                    | [**foreign**](https://cran.r-project.org/package=foreign)       |                                                                                                                         | Yes                  |
| “XBASE” database files                                | .dbf                    | [**foreign**](https://cran.r-project.org/package=foreign)       | [**foreign**](https://cran.r-project.org/package=foreign)                                                               | Yes                  |
| Weka Attribute-Relation File Format                   | .arff                   | [**foreign**](https://cran.r-project.org/package=foreign)       | [**foreign**](https://cran.r-project.org/package=foreign)                                                               | Yes                  |
| Data Interchange Format                               | .dif                    | **utils**                                                       |                                                                                                                         | Yes                  |
| Fortran data                                          | no recognized extension | **utils**                                                       |                                                                                                                         | Yes                  |
| Fixed-width format data                               | .fwf                    | **utils**                                                       | **utils**                                                                                                               | Yes                  |
| gzip comma-separated data                             | .csv.gz                 | **utils**                                                       | **utils**                                                                                                               | Yes                  |
| Apache Arrow (Parquet)                                | .parquet                | [**arrow**](https://cran.r-project.org/package=arrow)           | [**arrow**](https://cran.r-project.org/package=arrow)                                                                   | No                   |
| EViews                                                | .wf1                    | [**hexView**](https://cran.r-project.org/package=hexView)       |                                                                                                                         | No                   |
| Feather R/Python interchange format                   | .feather                | [**feather**](https://cran.r-project.org/package=feather)       | [**feather**](https://cran.r-project.org/package=feather)                                                               | No                   |
| Fast Storage                                          | .fst                    | [**fst**](https://cran.r-project.org/package=fst)               | [**fst**](https://cran.r-project.org/package=fst)                                                                       | No                   |
| JSON                                                  | .json                   | [**jsonlite**](https://cran.r-project.org/package=jsonlite)     | [**jsonlite**](https://cran.r-project.org/package=jsonlite)                                                             | No                   |
| Matlab                                                | .mat                    | [**rmatio**](https://cran.r-project.org/package=rmatio)         | [**rmatio**](https://cran.r-project.org/package=rmatio)                                                                 | No                   |
| OpenDocument Spreadsheet                              | .ods                    | [**readODS**](https://cran.r-project.org/package=readODS)       | [**readODS**](https://cran.r-project.org/package=readODS)                                                               | No                   |
| HTML Tables                                           | .html                   | [**xml2**](https://cran.r-project.org/package=xml2)             | [**xml2**](https://cran.r-project.org/package=xml2)                                                                     | No                   |
| Shallow XML documents                                 | .xml                    | [**xml2**](https://cran.r-project.org/package=xml2)             | [**xml2**](https://cran.r-project.org/package=xml2)                                                                     | No                   |
| YAML                                                  | .yml                    | [**yaml**](https://cran.r-project.org/package=yaml)             | [**yaml**](https://cran.r-project.org/package=yaml)                                                                     | No                   |
| Clipboard                                             | default is tsv          | [**clipr**](https://cran.r-project.org/package=clipr)           | [**clipr**](https://cran.r-project.org/package=clipr)                                                                   | No                   |
| [Google Sheets](https://www.google.com/sheets/about/) | as Comma-separated data |                                                                 |                                                                                                                         |                      |
| Graphpad Prism                                        | .pzfx                   | [**pzfx**](https://cran.r-project.org/package=pzfx)             | [**pzfx**](https://cran.r-project.org/package=pzfx)                                                                     | No                   |

Additionally, any format that is not supported by **rio** but that has a
known R implementation will produce an informative error message
pointing to a package and import or export function. Unrecognized
formats will yield a simple “Unrecognized file format” error.

## Other functions

### Convert

The `convert()` function links `import()` and `export()` by constructing
a dataframe from the imported file and immediately writing it back to
disk. `convert()` invisibly returns the file name of the exported file,
so that it can be used to programmatically access the new file.

``` r
convert("mtcars.sav", "mtcars.dta")
```

It is also possible to use **rio** on the command-line by calling
`Rscript` with the `-e` (expression) argument. For example, to convert a
file from Stata (.dta) to comma-separated values (.csv), simply do the
following:

    Rscript -e "rio::convert('iris.dta', 'iris.csv')"

### \*\_list

`import_list()` allows users to import a list of data frames from a
multi-object file (such as an Excel workbook, .Rdata file, zip
directory, or HTML file):

``` r
str(m <- import_list("mtcars.xlsx"))
```

    ## List of 2
    ##  $ mtcars:'data.frame':  32 obs. of  11 variables:
    ##   ..$ mpg : num [1:32] 21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
    ##   ..$ cyl : num [1:32] 6 6 4 6 8 6 8 4 4 6 ...
    ##   ..$ disp: num [1:32] 160 160 108 258 360 ...
    ##   ..$ hp  : num [1:32] 110 110 93 110 175 105 245 62 95 123 ...
    ##   ..$ drat: num [1:32] 3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
    ##   ..$ wt  : num [1:32] 2.62 2.88 2.32 3.21 3.44 ...
    ##   ..$ qsec: num [1:32] 16.5 17 18.6 19.4 17 ...
    ##   ..$ vs  : num [1:32] 0 0 1 1 0 1 0 1 1 1 ...
    ##   ..$ am  : num [1:32] 1 1 1 0 0 0 0 0 0 0 ...
    ##   ..$ gear: num [1:32] 4 4 4 3 3 3 3 4 4 4 ...
    ##   ..$ carb: num [1:32] 4 4 1 1 2 1 4 2 2 4 ...
    ##  $ iris  :'data.frame':  150 obs. of  5 variables:
    ##   ..$ Sepal.Length: num [1:150] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
    ##   ..$ Sepal.Width : num [1:150] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
    ##   ..$ Petal.Length: num [1:150] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
    ##   ..$ Petal.Width : num [1:150] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
    ##   ..$ Species     : chr [1:150] "setosa" "setosa" "setosa" "setosa" ...

`export_list()` makes it easy to export a list of (possibly named) data
frames to multiple files:

``` r
export_list(m, "%s.tsv")
c("mtcars.tsv", "iris.tsv") %in% dir()
```

    ## [1] TRUE TRUE

## Package Philosophy

The core advantage of **rio** is that it makes assumptions that the user
is probably willing to make. Eight of these are important:

1.  **rio** uses the file extension of a file name to determine what
    kind of file it is. This is the same logic used by Windows OS, for
    example, in determining what application is associated with a given
    file type. By removing the need to manually match a file type (which
    a beginner may not recognize) to a particular import or export
    function, **rio** allows almost all common data formats to be read
    with the same function. And if a file extension is incorrect, users
    can force a particular import method by specifying the `format`
    argument.

2.  **rio** uses `data.table::fread()` for text-delimited files to
    automatically determine the file format regardless of the extension.
    So, a CSV that is actually tab-separated will still be correctly
    imported. It’s also crazy fast.

3.  **rio**, wherever possible, does not import character strings as
    factors.

4.  **rio** supports web-based imports natively, including from SSL
    (HTTPS) URLs, from shortened URLs, from URLs that lack proper
    extensions, and from (public) Google Documents Spreadsheets.

5.  **rio** imports from from single-file .zip and .tar archives
    automatically, without the need to explicitly decompress them.
    Export to compressed directories is also supported.

6.  **rio** wraps a variety of faster, more stream-lined I/O packages
    than those provided by base R or the **foreign** package. It uses
    [**data.table**](https://cran.r-project.org/package=data.table) for
    delimited formats,
    [**haven**](https://cran.r-project.org/package=haven) for SAS,
    Stata, and SPSS files, smarter and faster fixed-width file import
    and export routines, and
    [**readxl**](https://cran.r-project.org/package=readxl) and
    [**openxlsx**](https://cran.r-project.org/package=openxlsx) for
    reading and writing Excel workbooks.

7.  **rio** stores metadata from rich file formats (SPSS, Stata, etc.)
    in variable-level attributes in a consistent form regardless of file
    type or underlying import function. These attributes are identified
    as:
    
      - `label`: a description of variable
      - `labels`: a vector mapping numeric values to character strings
        those values represent
      - `format`: a character string describing the variable storage
        type in the original file
    
    The `gather_attrs()` function makes it easy to move variable-level
    attributes to the data frame level (and `spread_attrs()` reverses
    that gathering process). These can be useful, especially, during
    file conversion to more easily modify attributes that are handled
    differently across file formats. As an example, the following idiom
    can be used to trim SPSS value labels to the 32-character maximum
    allowed by Stata:
    
    ``` r
    dat <- gather_attrs(rio::import("data.sav"))
    attr(dat, "labels") <- lapply(attributes(dat)$labels, function(x) {
        if (!is.null(x)) {
            names(x) <- substring(names(x), 1, 32)
        }
        x
    })
    export(spread_attrs(dat), "data.dta")
    ```
    
    In addition, two functions (added in v0.5.5) provide easy ways to
    create character and factor variables from these “labels”
    attributes. `characterize()` converts a single variable or all
    variables in a data frame that have “labels” attributes into
    character vectors based on the mapping of values to value labels.
    `factorize()` does the same but returns factor variables. This can
    be especially helpful for converting these rich file formats into
    open formats (e.g., `export(characterize(import("file.dta")),
    "file.csv")`.

8.  **rio** imports and exports files based on an internal S3 class
    infrastructure. This means that other packages can contain
    extensions to **rio** by registering S3 methods. These methods
    should take the form `.import.rio_X()` and `.export.rio_X()`, where
    `X` is the file extension of a file type. An example is provided in
    the [rio.db package](https://github.com/leeper/rio.db).

## Other projects

### GUIs

  - [**rioweb**](https://github.com/lbraglia/rioweb) that provides
    access to the file conversion features of rio.
  - [**GREA**](https://github.com/Stan125/GREA/) is an RStudio add-in
    that provides an interactive interface for reading in data using
    rio.

### Similar packages

  - [**reader**](https://cran.r-project.org/package=reader) handles
    certain text formats and R binary files
  - [**io**](https://cran.r-project.org/package=io) offers a set of
    custom formats
  - [**ImportExport**](https://cran.r-project.org/package=ImportExport)
    focuses on select binary formats (Excel, SPSS, and Access files) and
    provides a Shiny interface.
  - [**SchemaOnRead**](https://cran.r-project.org/package=SchemaOnRead)
    iterates through a large number of possible import methods until one
    works successfully
