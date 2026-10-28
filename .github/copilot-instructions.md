# tmdoc4r Copilot Instructions

## Repository model

`tmdoc4r-src.R` is the source of truth for the package. It is a single
literate R source file that embeds every generated package file using
`#' FILE: tmdoc4r/<path>` delimiters. `Rscript tmdoc4r-src.R --process
tmdoc4r-src.R` extracts those sections into the `tmdoc4r/` package tree; do
not make durable edits only in that generated tree because `make build`
removes and recreates it.

Keep package metadata, `NAMESPACE`, Rd documentation, R code, the executable
wrapper, and bundled files aligned in their corresponding `#' FILE:` sections.
The `DESCRIPTION` `Collate` order controls the generated R-file load order,
and `exportPattern("^[[:lower:]]+")` exports lowercase public functions.

At load time, `R/tmdoc4r.R` adds the bundled Tcl `tmdoc` libraries to
`auto_path` and requires both `tmdoc` and `mndoc`. The public `tmdoc()` API
invokes those Tcl packages to process an input document through Markdown to
HTML; it does not implement the document language in R. `ttangle()` extracts
code, while `df2md()` and `lipsum()` are supporting exported helpers.
The bundled runtime is in `inst/tmdoc/lib/`; package indexes declare tmdoc
0.20.0 and mndoc 0.15.5. The tmdoc 0.20.0 module sources include upstream
0.20.1 maintenance fixes, including the restored `filter-tblocks.tcl`.

The root `examples/` inputs are integration fixtures for supported markup,
code-chunk languages, and rendering features. Their checked-in HTML files are
the corresponding rendered examples. The vignette is also part of packaging:
the build converts `tmdoc4r-vignette.Rmd` with `tmdoc` and `mndoc`, then uses
WeasyPrint to create the PDF included in the package. The vignette includes
`tmdoc4r-vignette.toc`, so run `tmdoc <vignette> - --toc true` once to create
the TOC before running it again to render the document; both `make build` and
`make vignette` follow this two-pass sequence. Keep the vignette title's
package version current for each release.

## Commands

CI installs R, `tmdoc`, Graphviz, ImageMagick, TeX, and WeasyPrint before
running:

```sh
make build pkg=tmdoc4r
```

This regenerates the package, generates vignette artifacts, runs `R CMD
build`, and runs `R CMD check --ignore-vignettes`. There is no separate lint
command or conventional unit-test suite.

The build requires the external `tmdoc` and `mndoc` executables, WeasyPrint,
and TeX dependencies used by the `.Rnw` vignette. When preparing artifacts
without rebuilding that Sweave vignette, use `R CMD build
--no-build-vignettes tmdoc4r` after copying the freshly generated
`tmdoc4r-vignette.pdf` into `tmdoc4r/vignettes/`; check with
`R CMD check --ignore-vignettes --no-manual <package_tarball>`.

After a build, run all example integration checks with:

```sh
make ex pkg=tmdoc4r
```

Run one example (replace `ex-01.tmd` as appropriate) against the checked
package library with:

```sh
R_LIBS="$(pwd)/tmdoc4r.Rcheck" Rscript -e \
  "library(tmdoc4r); tmdoc('examples/ex-01.tmd', '/tmp/ex-01.html', css='examples/tmdoc.css')"
```

For a quick generated-documentation check after extracting the package:

```sh
Rscript tmdoc4r-src.R --check-man tmdoc4r
```

## Change conventions

- Add or change behavior in `tmdoc4r-src.R`, then regenerate before inspecting
  generated package files or running package-level checks.
- Preserve the `#' FILE:` delimiter format and use `#'` for content that must
  be extracted as non-R package files; unprefixed lines belong to an R source
  section.
- When changing supported document syntax or rendering behavior, update the
  closest example fixture and its expected HTML output, and keep the README
  or vignette usage documentation consistent.
- Keep generated files and build artifacts (`tmdoc4r/`, `tmdoc4r.Rcheck/`,
  package tarballs, temporary vignette output) out of source changes unless
  the task explicitly concerns a release artifact.
