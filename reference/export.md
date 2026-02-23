# Export

Write data.frame to a file

## Usage

``` r
export(x, file, format, ...)
```

## Arguments

- x:

  A data frame, matrix or a single-item list of data frame to be written
  into a file. Exceptions to this rule are that `x` can be a list of
  multiple data frames if the output file format is an OpenDocument
  Spreadsheet (.ods, .fods), Excel .xlsx workbook, .Rdata file, or HTML
  file, or a variety of R objects if the output file format is RDS or
  JSON. See examples.) To export a list of data frames to multiple
  files, use
  [`export_list()`](http://gesistsa.github.io/rio/reference/export_list.md)
  instead.

- file:

  A character string naming a file. Must specify `file` and/or `format`.

- format:

  An optional character string containing the file format, which can be
  used to override the format inferred from `file` or, in lieu of
  specifying `file`, a file with the symbol name of `x` and the
  specified file extension will be created. Must specify `file` and/or
  `format`. Shortcuts include: “,” (for comma-separated values), “;”
  (for semicolon-separated values), “\|” (for pipe-separated values),
  and “dump” for [`base::dump()`](https://rdrr.io/r/base/dump.html).

- ...:

  Additional arguments for the underlying export functions. This can be
  used to specify non-standard arguments. See examples.

## Value

The name of the output file as a character string (invisibly).

## Details

This function exports a data frame or matrix into a file with file
format based on the file extension (or the manually specified format, if
`format` is specified).

The output file can be to a compressed directory, simply by adding an
appropriate additional extensiont to the `file` argument, such as:
“mtcars.csv.tar”, “mtcars.csv.zip”, or “mtcars.csv.gz”.

`export` supports many file formats. See the documentation for the
underlying export functions for optional arguments that can be passed
via `...`

- Comma-separated data (.csv), using
  [`data.table::fwrite()`](https://rdrr.io/pkg/data.table/man/fwrite.html)

- Pipe-separated data (.psv), using
  [`data.table::fwrite()`](https://rdrr.io/pkg/data.table/man/fwrite.html)

- Tab-separated data (.tsv), using
  [`data.table::fwrite()`](https://rdrr.io/pkg/data.table/man/fwrite.html)

- SAS (.sas7bdat), using
  [`haven::write_sas()`](https://haven.tidyverse.org/reference/write_sas.html).

- SAS XPORT (.xpt), using
  [`haven::write_xpt()`](https://haven.tidyverse.org/reference/read_xpt.html).

- SPSS (.sav), using
  [`haven::write_sav()`](https://haven.tidyverse.org/reference/read_spss.html)

- SPSS compressed (.zsav), using
  [`haven::write_sav()`](https://haven.tidyverse.org/reference/read_spss.html)

- Stata (.dta), using
  [`haven::write_dta()`](https://haven.tidyverse.org/reference/read_dta.html).
  Note that variable/column names containing dots (.) are not allowed
  and will produce an error.

- Excel (.xlsx), using
  [`writexl::write_xlsx()`](https://docs.ropensci.org/writexl//reference/write_xlsx.html).
  `x` can also be a list of data frames; the list entry names are used
  as sheet names.

- R syntax object (.R), using
  [`base::dput()`](https://rdrr.io/r/base/dput.html) (by default) or
  [`base::dump()`](https://rdrr.io/r/base/dump.html) (if
  `format = 'dump'`)

- Saved R objects (.RData,.rda), using
  [`base::save()`](https://rdrr.io/r/base/save.html). In this case, `x`
  can be a data frame, a named list of objects, an R environment, or a
  character vector containing the names of objects if a corresponding
  `envir` argument is specified.

- Serialized R objects (.rds), using
  [`base::saveRDS()`](https://rdrr.io/r/base/readRDS.html). In this
  case, `x` can be any serializable R object.

- Serialized R objects (.qs2), using
  [`qs2::qs_save()`](https://rdrr.io/pkg/qs2/man/qs_save.html).

- "XBASE" database files (.dbf), using
  [`foreign::write.dbf()`](https://rdrr.io/pkg/foreign/man/write.dbf.html)

- Weka Attribute-Relation File Format (.arff), using
  [`foreign::write.arff()`](https://rdrr.io/pkg/foreign/man/write.arff.html)

- Fixed-width format data (.fwf), using
  [`utils::write.table()`](https://rdrr.io/r/utils/write.table.html)
  with `row.names = FALSE`, `quote = FALSE`, and `col.names = FALSE`

- [CSVY](https://github.com/csvy) (CSV with a YAML metadata header)
  using
  [`data.table::fwrite()`](https://rdrr.io/pkg/data.table/man/fwrite.html).

- Apache Arrow Parquet (.parquet), using
  [`nanoparquet::write_parquet()`](https://nanoparquet.r-lib.org/reference/write_parquet.html)

- Feather R/Python interchange format (.feather), using
  [`arrow::write_feather()`](https://arrow.apache.org/docs/r/reference/write_feather.html)

- Fast storage (.fst), using
  [`fst::write.fst()`](http://www.fstpackage.org/reference/write_fst.md)

- JSON (.json), using
  [`jsonlite::toJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html).
  In this case, `x` can be a variety of R objects, based on class
  mapping conventions in this paper: <https://arxiv.org/abs/1403.2805>.

- Matlab (.mat), using
  [`rmatio::write.mat()`](https://rdrr.io/pkg/rmatio/man/write.mat-methods.html)

- OpenDocument Spreadsheet (.ods, .fods), using
  [`readODS::write_ods()`](https://docs.ropensci.org/readODS/reference/write_ods.html)
  or
  [`readODS::write_fods()`](https://docs.ropensci.org/readODS/reference/write_ods.html).

- HTML (.html), using a custom method based on
  [`xml2::xml_add_child()`](http://xml2.r-lib.org/reference/xml_replace.md)
  to create a simple HTML table and
  [`xml2::write_xml()`](http://xml2.r-lib.org/reference/write_xml.md) to
  write to disk.

- XML (.xml), using a custom method based on
  [`xml2::xml_add_child()`](http://xml2.r-lib.org/reference/xml_replace.md)
  to create a simple XML tree and
  [`xml2::write_xml()`](http://xml2.r-lib.org/reference/write_xml.md) to
  write to disk.

- YAML (.yml), using
  [`yaml::write_yaml()`](https://yaml.r-lib.org/reference/write_yaml.html),
  default to write the content with UTF-8. Might not work on some older
  systems, e.g. default Windows locale for R \<= 4.2.

- Clipboard export (on Windows and Mac OS), using
  [`utils::write.table()`](https://rdrr.io/r/utils/write.table.html)
  with `row.names = FALSE`

When exporting a data set that contains label attributes (e.g., if
imported from an SPSS or Stata file) to a plain text file,
[`characterize()`](http://gesistsa.github.io/rio/reference/characterize.md)
can be a useful pre-processing step that records value labels into the
resulting file (e.g., `export(characterize(x), "file.csv")`) rather than
the numeric values.

Use
[`export_list()`](http://gesistsa.github.io/rio/reference/export_list.md)
to export a list of dataframes to separate files.

## See also

[`characterize()`](http://gesistsa.github.io/rio/reference/characterize.md),
[`import()`](http://gesistsa.github.io/rio/reference/import.md),
[`convert()`](http://gesistsa.github.io/rio/reference/convert.md),
[`export_list()`](http://gesistsa.github.io/rio/reference/export_list.md)

## Examples

``` r
## For demo, a temp. file path is created with the file extension .csv
csv_file <- tempfile(fileext = ".csv")
## .xlsx
xlsx_file <- tempfile(fileext = ".xlsx")

## create CSV to import
export(iris, csv_file)

## You can certainly export your data with the file name, which is not a variable:
## import(mtcars, "car_data.csv")

## pass arguments to the underlying function
## data.table::fwrite is the underlying function and `col.names` is an argument
export(iris, csv_file, col.names = FALSE)

## export a list of data frames as worksheets
export(list(a = mtcars, b = iris), xlsx_file)

# NOT RECOMMENDED

## specify `format` to override default format
export(iris, xlsx_file, format = "csv") ## That's confusing
## You can also specify only the format; in the following case
## "mtcars.dta" is written [also confusing]

## export(mtcars, format = "stata")
```
