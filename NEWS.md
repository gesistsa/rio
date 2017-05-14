# CHANGES TO v0.5.2

 * Fixed a bug in `.import.rio_xlsx()` when `readxl = FALSE`. (#152, h/t Danny Parsons)
 * Added a new function `spread_attrs()` that reverses the `gather_attrs()` operation.
 * Expanded test coverage.

# CHANGES TO v0.5.1

 * `export()` now sets variables with a "labels" attribute to **haven**'s "labelled" class.

# CHANGES TO v0.5.0

 * CRAN Release.
 * Restored import of **openxlsx** so that writing to xlsx is supported on install. (#150)

# CHANGES TO v0.4.28

 * Improved documentation of mapping between file format support and the packages used for each format. (#151, h/t Patrick Kennedy)
 * `import_list()` now returns a `NULL` entry for any failed imports, with a warning. (#149)
 * `import_list()` gains additional arguments `rbind_fill` and `rbind_label` to control rbind-ing behavior. (#149)

# CHANGES TO v0.4.27

 * Import to and export from the clipboard now relies on `clipr::read_clip()` and `clipr::write_clip()`, respectively, thus (finally) providing Linux support. (#105, h/t Matthew Lincoln)
 * Added an `rbind` argument to `import_list()`. (#149)
 * Added a `setclass` argument to `import_list()`, ala the same in `import()`.
 * Switched `requireNamespace()` calls to `quietly = TRUE`.

# CHANGES TO v0.4.26

 * Further fixes to .csv.gz import/export. (#146, h/t Trevor Davis)

# CHANGES TO v0.4.25

 * Remove unecessary **urltools** dependency.
 * New function `import_list()` returns a list of data frames from a multi-object Excel Workbook, .Rdata file, zip directory, or HTML file. (#126, #129)
 * `export()` can now write a list of data frames to an Excel (.xlsx) workbook. (#142, h/t Jeremy Johnson)
 * `export()` can now write a list of data frames to an HTML (.html) file.

# CHANGES TO v0.4.24

 * Verbosity of `export(format = "fwf")` now depends on `options("verbose")`. 
 * Fixed various errors, warnings, and messages in fixed-width format tests.
 * Modified defaults and argument handling in internal function `read_delim()`.
 * Fixed handling of "data.table", "tibble", and "data.frame" classes in `set_class()`. (#144)

# CHANGES TO v0.4.23

 * Moved all non-critical format packages to Suggests, rather than Imports. (#143)
 * Added support for Matlab formats. (#78, #98)
 * Added support for fst format. (#138)

# CHANGES TO v0.4.22

 * Rearranged README.
 * Bumped readxl dependency to `>= 0.1.1` (#130, h/t Yongfa Chen)
 * Pass explicit `excel_format` arguments when using **readxl** functions. (#130)
 * Google Spreadsheets can now be imported using any of the allowed formats (CSV, TSV, XLSX, ODS).
 * Added support for writing to ODS files via `readODS::write_ods()`. (#96)

# CHANGES TO v0.4.21

 * Handle HTML tables with `<tbody>` elements. (h/t Mohamed Elgoussi)

# CHANGES TO v0.4.20

 * Fixed a big in the `.import.rio_xls()` and `.import.rio_xlsx()` where the `sheet` argument would return an error.

# CHANGES TO v0.4.19

 * Fixed a bug in the import of delimited files when `fread = FALSE`. (#133, h/t Christopher Gandrud)

# CHANGES TO v0.4.18

 * With new data.table release, export using `fwrite()` is now the default for text-based file formats.

# CHANGES TO v0.4.17

 * Fixed a bug in `.import.rio_xls()` wherein the `which` argument was ignored. (h/t Mohamed Elgoussi)

# CHANGES TO v0.4.16

 * Added support for importing from multi-table HTML files using the `which` argument. (#126)

# CHANGES TO v0.4.15

 * Improved behavior of `import()` and `export()` with respect to unrecognized file types. (#124, #125, h/t Jason Becker)
 * Added explicit tests of the S3 extension mechanism for `.import()` and `.export()`.
 * Attempt to recognize compressed but non-archived file formats (e.g., ".csv.gz"). (#123, h/t trevorld)

# CHANGES TO v0.4.14

 * Update import and export methods to use new xml2 for XML and HTML export. (#86)

# CHANGES TO v0.4.13

 * Fix failing tests related to stricter variable name handling for Stata files in development version of haven. (#113, h/t Hadley Wickham)
 * Added support for export of .sas7bdat files via haven (#116)
 * Restored support for import from SPSS portable via haven (#116)
 * Updated import methods to reflect changed formal argument names in haven. (#116)
 * Converted to roxygen2 documentation and made NEWS an explicit markdown file.

# CHANGES TO v0.4.12

 * rio sets `options(datatable.fread.dec.experiment=FALSE)` during onLoad to address a Unix-specific locale issue.

# CHANGES TO v0.4.11

 * Note unsupported NumPy i/o via RcppCNPy. (#112)
 * Fix import of European-style CSV files (sep = "," and sep2 = ";"). (#106, #107, h/t Stani Stadlmann)

# CHANGES TO v0.4.10

 * Changed feather Imports to Suggests to make rio installable on older R versions. (#104)
 * Noted new RStudio add-in, GREA, that uses rio. (#109)
 * Migrated CSVY-related code to separate package (https://github.com/leeper/csvy/). (#111)

# CHANGES TO v0.4.9

 * Removed unnecessary error in xlsx imports. (#103, h/t Kevin Wright)

# CHANGES TO v0.4.8

 * Fixed a bug in the handling of "labelled" class variables imported from haven. (#102, h/t Pierre LaFortune)

# CHANGES TO v0.4.7

 * Improved use of the `sep` argument for import of delimited files. (#99, h/t Danny Parsons)
 * Removed support for import of SPSS Portable (.por) files, given deprecation from haven. (#100)

# CHANGES TO v0.4.5

 * Fixed other tests to remove (unimportant) warnings.
 * Fixed a failing test of file compression that was found in v0.4.3 on some platforms.

# CHANGES TO v0.4.3

 * Improved, generalized, tested, and expanded documentation of `which` argument in `import()`.
 * Expanded test suite and made some small fixes.

# CHANGES TO v0.4.2

 * Added support to import and export to `feather` data serialization format. (#88, h/t Jason Becker)

# CHANGES TO v0.4.1

 * Fixed behavior of `gather_attrs()` on a data.frame with no attributes to gather. (#94)
 * Removed unrecognized file format error for import from compressed files. (#93)

# CHANGES TO v0.4.0

 * CRAN Release.

# CHANGES TO v0.3.19

 * Added a `gather_attrs()` function that moves variable-level attributes to the data.frame level. (#80)
 * Added preliminary support for import from HTML tables (#86)

# CHANGES TO v0.3.18

 * Added support for export to HTML tables. (#86)

# CHANGES TO v0.3.17

 * Fixed a bug in import from remote URLs with incorrect file extensions.

# CHANGES TO v0.3.16

 * Added support for import from fixed-width format files via `readr::read_fwf()` with a specified `widths` argument. This may enable faster import of these types of files and provides a base-like interface for working with readr. (#48)

# CHANGES TO v0.3.15

 * Added support for import from and export to yaml. (#83)
 * Fixed a bug when reading from an uncommented CSVY yaml header that contained single-line comments. (#84, h/t Tom Aldenberg)

# CHANGES TO v0.3.14

 * Diagnostic messages were cleaned up to facilitate translation. (#57)

# CHANGES TO v0.3.12

 * `.import()` and `.export()` are now exported S3 generics and documentation has been added to describe how to write rio extensions for new file types. An example of this functionality is shown in the new suggested "rio.db" package.

# CHANGES TO v0.3.11

 * `import()` now uses xml2 to read XML structures and `export()` uses a custom method for writing to XML, thereby negating dependency on the XML package. (#67)
 * Enhancements were made to import and export of CSVY to store attribute metadata as variable-level attributes (like imports from binary file formats).
 * `import()` gains a `which` argument that is used to select which file to return from within a compressed tar or zip archive.
 * Export to tar now tries to correct for bugs in `tar()` that are being fixed in base R via [PR#16716](https://bugs.r-project.org/bugzilla/show_bug.cgi?id=16716).

# CHANGES TO v0.3.10

 * Fixed a bug in `import()` (introduced in #62, 7a7480e5) that prevented import from clipboard. (h/t Kevin Wright)
 * `export()` returns a character string. (#82)

# CHANGES TO v0.3.9

 * The use of `import()` for SAS, Stata, and SPSS files has been streamlined. Regardless of whether the `haven = TRUE` argument is used, the data.frame returned by `import()` should now be (nearly) identical, with all attributes stored at the variable rather than data.frame level. This is a non-backwards compatible change. (#80)

# CHANGES TO v0.3.8

 * Fixed error in export to CSVY with a commented yaml header. (#81, h/t Andrew MacDonald)

# CHANGES TO v0.3.7

 * `export()` now allows automatic file compression as tar, gzip, or zip using the `file` argument (e.g., `export(iris, "iris.csv.zip")`).

# CHANGES TO v0.3.6

 * Expanded verbosity of `export()` for fixed-width format files and added a commented header containing column class and width information.
 * Exporting factors to fixed-width format now saves those values as integer rather than numeric.
 * Expanded test suite and separated tests into format-specific files. (#51)

# CHANGES TO v0.3.5

 * Export of CSVY files now includes commenting the yaml header by default. Import of CSVY accommodates this automatically. (#74)

# CHANGES TO v0.3.3

 * Export of CSVY files and metadata now supported by `export()`. (#73)
 * Import of CSVY files now stores dataset-level metadata in attributes of the output data.frame. (#73, h/t Tom Aldenberg)
 * When rio receives an unrecognized file format, it now issues a message. The new internal `.import.default()` and `.export.default()` then produce an error. This enables add-on packages to support additional formats through new s3 methods of the form `.import.rio_EXTENSION()` and `.export.rio_EXTENSION()`.

# CHANGES TO v0.3.2

 * Use S3 dispatch internally to call new (unexported) `.import()` and `.export()` methods. (#42, h/t Jason Becker)

# CHANGES TO v0.3.0

 * Release to CRAN.
 * Set a default numerical precision (of 2 decimal places) for export to fixed-width format.

# CHANGES TO v0.2.13

 * Import stats package for `na.omit()`.

# CHANGES TO v0.2.11

 * Added support for direct import from Google Sheets. (#60, #63, h/t Chung-hong Chan)

# CHANGES TO v0.2.7

 * Refactored remote file retrieval into separate (non-exported) function used by `import()`. (#62)
 * Added test sutie to test file conversion.
 * Expanded test suite to include test of all export formats.

# CHANGES TO v0.2.6

 * Cleaned up NAMESPACE file.

# CHANGES TO v0.2.5

 * If file format for a remote file cannot be identified from the supplied URL or the final URL reported by `curl::curl_fetch_memory()`, the HTTP headers are checked for a filename in the Content-Disposition header. (#36)
 * Removed longurl dependency. This is no longer needed because we can identify formats using curl's url argument.
 * Fixed a bug related to importing European-style ("csv2") format files. (#44)
 * Updated CSVY import to embed variable-level metadata. (#52)
 * Use `urltools::url_parse()` to extract file extensions from complex URLs (e.g., those with query arguments). (#56)
 * Fixed NAMESPACE notes for base packages. (#58)

# CHANGES TO v0.2.4

 * Modified behavior so that files imported using haven now store variable metadata at the data.frame level by default (unlike the default behavior in haven, which can cause problems). (#37, h/t Ista Zahn)
 * Added support for importing CSVY (http://csvy.org/) formatted files. (#52)
 * Added import dependency on data.table 1.9.5. (#39)

# CHANGES TO v0.2.2

 * Uses the longurl package to expand shortened URLs so that their file type can be easily determined.

# CHANGES TO v0.2.1

 * Improved support for importing from compressed directories, especially web-based compressed directories. (#38)
 * Add import dependency on curl >= 0.6 to facilitate content type parsing and format inference from URL redirects. (#36)
 * Add bit64 to `Suggests` to remove an `import` warning.

# CHANGES TO v0.2

 * `import` always returns a data.frame, unless `setclass` is specified. (#22)
 * Added support for import from legacy Excel (.xls) files `readxl::read_excel`, making its use optional. (#19)
 * Added support for import from and export to the system clipboard on Windows and Mac OS.
 * Added support for export to simple XML documents. (#12)
 * Added support for import from simple XML documents via `XML::xmlToDataFrame`. (#12)
 * Added support for import from ODS spreadsheet formats. (#12, h/t Chung-hong Chan)
 * Use `data.table::fread` by default for reading delimited files. (#3)
 * Added support for import and export of `dput` and `dget` objects. (#10)
 * Added support for reading from compressed archives (.zip and .tar). (#7)
 * Added support for writing to fixed-width format. (#8)
 * Set `stringsAsFactors = FALSE` as default for reading tabular data. (#4)
 * Added support for HTTPS imports. (#1, h/t Christopher Gandrud)
 * Added support for automatic file naming in `export` based on object name and file format. (#5)
 * Exposed `convert` function.
 * Added vignette, knitr-generated README.md, and updated documentation. (#2)
 * Added some non-exported functions to simplify argument passing and streamline package API. (#6)
 * Separated `import`, `export`, `convert`, and utilities into separate source code files.
 * Expanded the set of supported file types/extensions, switched SPSS, SAS, and Stata formats to **haven**, making its use optional.

# CHANGES TO v0.1.2

 * Updated documentation and fixed a bug in csv import without header.

# CHANGES TO v0.1.1

 * Initial release
