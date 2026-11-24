#!/usr/bin/env Rscript

usage <- function() {
  cat("Usage: tmdoc4r INFILE.Rmd OUTFILE.{html,pdf,md} [CSSFILE]\n")
}

argv <- commandArgs(trailingOnly=TRUE)
if (length(argv) == 1L && argv[[1]] %in% c("-h", "--help")) {
  usage()
  quit(status=0L)
}
if (length(argv) < 2L) {
  usage()
  quit(status=2L)
}

infile <- argv[[1]]
outfile <- argv[[2]]
css <- if (length(argv) >= 3L) argv[[3]] else NULL

if (!file.exists(infile)) {
  stop(sprintf("Input file '%s' does not exist", infile))
}

library(tmdoc4r)

extension <- tolower(tools::file_ext(outfile))
if (!extension %in% c("html", "htm", "pdf", "md")) {
  stop("Output must have one of these extensions: .html, .pdf or .md")
}

html_file <- outfile
if (extension == "pdf") {
  html_file <- tempfile("tmdoc4r-", fileext=".html")
  on.exit(unlink(html_file), add=TRUE)
}

# The first pass writes the included TOC and the second pass embeds it.
tmdoc(infile, html_file, css=css, mathjax=TRUE, quiet=TRUE, toc=TRUE)
tmdoc(infile, html_file, css=css, mathjax=TRUE, quiet=TRUE, toc=TRUE)

if (extension == "pdf") {
  tcltk::.Tcl("if {[info commands ::exitorig] eq {}} { rename ::exit ::exitorig }; proc ::exit {args} { return }")
  quote <- function(value) paste0("{", gsub("([\\\\{}])", "\\\\\\1", value), "}")
  tcltk::.Tcl(paste("set ::argv [list",
                    quote(normalizePath(html_file, mustWork=TRUE)),
                    quote(normalizePath(outfile, mustWork=FALSE)),
                    "]"))
  tcltk::.Tcl("set ::argv0 mndoc")
  tcltk::.Tcl("mndoc::main $argv")
  unlink(html_file)
}
