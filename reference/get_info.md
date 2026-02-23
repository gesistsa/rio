# Get File Info

A utility function to retrieve the file information of a filename, path,
or URL.

## Usage

``` r
get_info(file)

get_ext(file)
```

## Arguments

- file:

  A character string containing a filename, file path, or URL.

## Value

For `get_info()`, a list is return with the following slots

- `input` file extension or information used to identify the possible
  file format

- `format` file format, see `format` argument of
  [`import()`](http://gesistsa.github.io/rio/reference/import.md)

- `type` "import" (supported by default); "suggest" (supported by
  suggested packages, see
  [`install_formats()`](http://gesistsa.github.io/rio/reference/install_formats.md));
  "enhance" and "known " are not directly supported; `NA` is unsupported

- `format_name` name of the format

- `import_function` What function is used to import this file

- `export_function` What function is used to export this file

- `file` `file`

For `get_ext()`, just `input` (usually file extension) is returned;
retained for backward compatibility.

## Examples

``` r
get_info("starwars.xlsx")
#> $input
#> [1] "xlsx"
#> 
#> $format
#> [1] "xlsx"
#> 
#> $type
#> [1] "import"
#> 
#> $format_name
#> [1] "Excel"
#> 
#> $import_function
#> [1] "readxl::read_xlsx"
#> 
#> $export_function
#> [1] "writexl::write_xlsx"
#> 
#> $file
#> [1] "starwars.xlsx"
#> 
get_info("starwars.ods")
#> $input
#> [1] "ods"
#> 
#> $format
#> [1] "ods"
#> 
#> $type
#> [1] "suggest"
#> 
#> $format_name
#> [1] "OpenDocument Spreadsheet"
#> 
#> $import_function
#> [1] "readODS::read_ods"
#> 
#> $export_function
#> [1] "readODS::write_ods"
#> 
#> $file
#> [1] "starwars.ods"
#> 
get_info("https://github.com/ropensci/readODS/raw/v2.1/starwars.ods")
#> $input
#> [1] "ods"
#> 
#> $format
#> [1] "ods"
#> 
#> $type
#> [1] "suggest"
#> 
#> $format_name
#> [1] "OpenDocument Spreadsheet"
#> 
#> $import_function
#> [1] "readODS::read_ods"
#> 
#> $export_function
#> [1] "readODS::write_ods"
#> 
#> $file
#> [1] "https://github.com/ropensci/readODS/raw/v2.1/starwars.ods"
#> 
get_info("~/duran_duran_rio.mp3")
#> $input
#> [1] "mp3"
#> 
#> $format
#> [1] "mp3"
#> 
#> $type
#> [1] "unknown"
#> 
#> $format_name
#> [1] NA
#> 
#> $import_function
#> [1] NA
#> 
#> $export_function
#> [1] NA
#> 
#> $file
#> [1] "~/duran_duran_rio.mp3"
#> 
get_ext("clipboard") ## "clipboard"
#> [1] "clipboard"
get_ext("https://github.com/ropensci/readODS/raw/v2.1/starwars.ods")
#> [1] "ods"
```
