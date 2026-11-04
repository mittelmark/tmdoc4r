# AGENTS.md

Guidance for coding agents working in this repository.

A companion document with additional build/CI caveats lives at
`.github/copilot-instructions.md` (user-maintained) — consult both.
Work-session records live in `session-YYYY-MM-DD.md` files at the repo
root; `session-2026-11-04.md` covers the 0.6.0 release and the
vignette-index fix.

## What this project is

**tmdoc4r** is an R package that embeds the Tcl packages
[tmdoc](https://github.com/mittelmark/tmdoc) (literate programming) and
[mndoc](https://github.com/mittelmark/mndoc) (Markdown → HTML/PDF) **in one
functionality for R users**. There is a single main command,
`tmdoc4r::tmdoc()`, which converts R Markdown (`.Rmd`) or tmdoc (`.tmd`)
documents **directly to HTML** and — since the bundled mndoc 0.17.0 —
**directly to PDF** when headless Chromium/Chrome or WeasyPrint is
installed. It is positioned as a lightweight (< 1MB) alternative to
knitr/rmarkdown whose only dependency is `tcltk`.

The Tcl packages run **in-process** through R's `tcltk` interpreter — no
external `tclsh` is needed at runtime (the external `tmdoc`/`mndoc` CLI
binaries are only needed for *building the package artifacts*, see
Commands).

Current versions (keep in sync when updating):

| Component | Version | Where declared |
| --- | --- | --- |
| tmdoc4r package | **0.6.0** | `tmdoc4r-src.R` (`#' Version:`) → generated `DESCRIPTION` |
| bundled tmdoc | **0.21.1** | `inst/tmdoc/lib/tmdoc/pkgIndex.tcl` |
| bundled mndoc | **0.17.0** | `inst/tmdoc/lib/mndoc/pkgIndex.tcl` |
| bundled Markdown (tcllib) | **1.2.5** | `inst/tmdoc/lib/markdown/markdown.tcl` (see pitfall below) |
| bundled tblocks | 0.0.11 | `inst/tmdoc/lib/tblocks/pkgIndex.tcl` |

License: MIT (see `DESCRIPTION`). Upstream sibling checkouts (not required,
but handy for updating the bundle): `~/workspace/tmdoc`,
`~/workspace/mndoc`.

## Repository model — `tmdoc4r-src.R` is the source of truth

`tmdoc4r-src.R` is a single literate R source file that embeds every
generated package file between `#' FILE: tmdoc4r/<path>` delimiters:

```sh
Rscript tmdoc4r-src.R --process tmdoc4r-src.R   # extract #' FILE: sections -> tmdoc4r/
Rscript tmdoc4r-src.R --vignettex tmdoc4r-src.R # write examples Rmd + COPY inst/ into tmdoc4r/
```

- **`--process` does NOT copy `inst/`** (there is a `## TODO` in the
  source); the `inst/tmdoc/lib` bundle reaches the package tree only via
  `--vignettex`. Always run both, in that order — `make build` and
  `make vignette` assume the tree exists.
- The generated `tmdoc4r/` tree is **disposable**. Never make durable edits
  there; edit `tmdoc4r-src.R` and regenerate. This applies to `R/`,
  `man/`, `NAMESPACE`, `DESCRIPTION`, `NEWS`, `exec/` — all are `#' FILE:`
  sections of the source file.
- `DESCRIPTION` `Collate:` controls generated R-file load order;
  `exportPattern("^[[:lower:]]+")` exports the lowercase public functions
  (`tmdoc`, `ttangle`, `df2md`, `lipsum`).

## Bundled Tcl runtime — `inst/tmdoc/lib/`

Layout: `tmdoc/`, `mndoc/` plus vendored dependencies `bibtex`, `citer`,
`cmdline`, `fileutil`, `markdown`, `tblocks`, `tcrd`, `tdot`, `textutil`,
`tsvg`, `yaml`.

At load time `R/tmdoc4r.R` (generated) appends
`system.file("tmdoc/lib", package="tmdoc4r")` to the Tcl `auto_path` and
does `package require tmdoc` + `package require mndoc`.

### Updating the bundle to new tmdoc/mndoc releases

1. tmdoc runtime files — copy from the tmdoc checkout
   (`~/workspace/tmdoc/modules/tmdoc/`, fetched at the pinned `*_REF`
   commits of the tmdoc Makefile):
   `pkgIndex.tcl tmdoc.tcl tmdoc.sty filter-*.tcl` (and `tmdoc.css` /
   `small.css` if they changed) → `inst/tmdoc/lib/tmdoc/`.
2. mndoc — copy `mndoc.tcl` + `pkgIndex.tcl` from
   `~/workspace/tmdoc/modules/mndoc/` (pinned `MNDOC_REF`) and
   `mndoc.css` + `book.css` + `tmdoc.css` from
   `~/workspace/mndoc/mndoc/` →
   `inst/tmdoc/lib/mndoc/` (`book.css` is the flat greyish traditional-book
   layout from mndoc ≥ 0.16.0; a bare `--css book.css` / `css="book.css"`
   resolves it from this bundle directory).
3. Other dependency modules only if `diff -rq` against
   `~/workspace/tmdoc/modules/<name>/` shows a real change.
4. Regenerate (`--process` + `--vignettex`) and verify:

```sh
tclsh <<'EOF'
lappend auto_path inst/tmdoc/lib
puts [package require tmdoc]; puts [package require mndoc]
EOF
```

**Pitfall — do not downgrade `markdown`:** the bundled tcllib Markdown
module is **1.2.5**, newer than tmdoc's `TCLLIB_REF` pin (1.2.4). Version
1.2.5 contains the pipe-symbol-inside-backticks table fix that tmdoc4r
0.4.0 depends on (regex at `markdown.tcl` line ~444). Syncing it "down"
from `modules/markdown` silently re-introduces that bug.

No runtime file from `inst/tmdoc/assets/`-style paths is needed: the
`assets/...` strings in `citer.tcl` are documentation examples only.

## How `tmdoc()` works (R → Tcl → output)

```r
tmdoc(infile, outfile=NULL, css=NULL, quiet=FALSE, mathjax=NULL,
      refresh=NULL, inline=TRUE, toc=FALSE, ...)
```

Two stages, both executed **in-process** via `tcltk::.Tcl()`:

1. `tmdoc::main` weaves `infile` → `mdfile` (same name with `.md`
   extension), evaluating code chunks (R, Python, Octave, Julia, Tcl,
   shell, diagrams, …).
2. `mndoc::main` converts `mdfile` → `outfile`; **the output format follows
   the outfile extension** (`.html` default, `.md`, and since mndoc 0.17.0
   `.pdf`).

Argument mapping: `css` → `--css`, `toc` → `--toc true` (TOC file needs a
**second run** to be embedded), `mathjax` → `--mathjax true`, `refresh` →
`--refresh N`, `inline` → `--base64 true|false`. `::exit` is stubbed to a
no-op and the Tcl cwd is switched to `getwd()` around the calls. Inputs
with code extensions (`.r`, `.py`, `.tcl`, …) take a different branch that
extracts `#'` documentation comments instead of weaving.

**PDF output (new in bundled mndoc 0.17.0):** `mndoc::pdf-engine` picks the
first of `chromium-browser`, `chromium`, `google-chrome`,
`google-chrome-stable`, `chrome`, and falls back to `weasyprint`.
Consequences:

- With a browser engine, CSS *and* **MathJax equations render** in the PDF
  (headless Chrome executes JavaScript; `--virtual-time-budget` waits for
  it).
- With the WeasyPrint fallback there is no JavaScript: MathJax equations
  stay as raw `$...$` text in the PDF. Equations-as-images (CodeCogs
  `.mtex` chunks) work everywhere.

## Commands

```sh
# regenerate the package tree after editing tmdoc4r-src.R
Rscript tmdoc4r-src.R --process tmdoc4r-src.R
Rscript tmdoc4r-src.R --vignettex tmdoc4r-src.R

# quick generated-doc check
Rscript tmdoc4r-src.R --check-man tmdoc4r

# vignette only (two-pass: 1st run writes the .toc, 2nd embeds it)
make vignette

# book-layout showcase of the vignette -> tmdoc4r-tutorial-book.{html,pdf}
# (repo root, untracked, illustrative only - never packaged; attach to the
# GitHub release like mndoc's manual-book-*.pdf)
make book

# full build: regenerate + vignette artifacts + R CMD build + R CMD check
make build pkg=tmdoc4r

# integration checks of all examples/ fixtures against the checked package
# (regenerates examples/*.html in place; needs abcm2ps + examples/lipsum.txt)
make ex pkg=tmdoc4r

# one example by hand
R_LIBS="$(pwd)/tmdoc4r.Rcheck" Rscript -e \
  "library(tmdoc4r); tmdoc('examples/ex-01.tmd', '/tmp/ex-01.html', css='examples/tmdoc.css')"

# local fallback when TeX gaps block the Sweave vignette/manual (see
# Environment facts): run AFTER `make build` - that target seeds inst/doc
# with the vignette Rnw+PDF once its full-build attempt is done, so this
# build ships a vignette index and vignette() works after installation
R CMD build --no-build-vignettes tmdoc4r
R CMD check --ignore-vignettes --no-manual tmdoc4r_<version>.tar.gz
```

Requirements: R with `tcltk`; for artifact builds additionally the
**external `tmdoc` and `mndoc` CLIs on PATH** (`~/.local/bin` — install or
refresh with the official installer;
`tmdoc --upgrade` works from 0.21.1 on), WeasyPrint and/or Chromium for
the vignette PDF, TeX (`texlive-latex-extra`) for the `.Rnw` Sweave
vignette, Graphviz/ImageMagick for diagram examples, and
`python3 -c 'import matplotlib'` for the vignette's Python plotting
example (`pyexample.svg`). For `make ex` additionally **`abcm2ps`**
(ABC-music → SVG chunk in `examples/ex-09.tmd`; user-locally installable
without root: `dnf download abcm2ps && rpm2cpio abcm2ps-*.rpm | cpio -idm
-D ~/.local/opt/abcm2ps`, symlink `usr/bin/abcm2ps` into `~/.local/bin`)
and the untracked input **`examples/lipsum.txt`** (copy it from
`~/workspace/tmdoc/examples/lipsum.txt`; `ex-11` includes it 9× — without
it the fixture fills up with `Error: file 'lipsum.txt' does not exists!`).
CI (`.github/workflows/r.yml`) installs these
and runs `make build`, then uploads `tmdoc4r_<version>.tar.gz` as artifact.

There is no lint command and no unit-test suite; the `examples/`
`.tmd`/`.Rmd` inputs plus their checked-in HTML files are the integration
fixtures.

## The vignette

`tmdoc4r-vignette.Rmd` (repo root) is processed **by tmdoc + mndoc
themselves**, not by knitr:

```sh
tmdoc tmdoc4r-vignette.Rmd - --toc true            # pass 1: writes .toc
tmdoc tmdoc4r-vignette.Rmd - --toc true | mndoc - tmdoc4r/inst/doc/tmdoc4r-vignette.html --css examples/tmdoc.css --mathjax true
mndoc tmdoc4r/inst/doc/tmdoc4r-vignette.html tmdoc4r/inst/doc/tmdoc4r-vignette.pdf
```

- The TOC include (`` `tcl include tmdoc4r-vignette.toc` ``) makes a
  **two-pass run mandatory** — both `make build` and `make vignette` do it.
- `--mathjax true` on the HTML step is required for the *MathJax
  Equations* section; the PDF step (`mndoc <html> <pdf>`) replaced the old
  `weasyprint --stylesheet small.css` call — mndoc picks the browser
  engine first (so MathJax renders), injects its own print styles
  (`@page` follows `PAPER`/`LC_PAPER`, default A4) and ignores `--css` for
  HTML input; `small.css` is no longer used by the Makefile.
- Keep the vignette title's package version (`tmdoc4r <version> vignette`)
  and its `date:` header in `tmdoc4r-src.R`-adjacent content current per
  release.
- Root-level `tmdoc4r-vignette.html` / `.pdf` (and `tmdoc4r-examples.html`)
  are local preview artifacts (untracked) — `make build` moves the
  generated htmls out of `inst/doc` to the repo root; the packaged
  vignette is `inst/doc/tmdoc4r-vignette.{Rnw,pdf}` (what `vignette()`
  serves) plus the `vignettes/tmdoc4r-vignette.Rnw` source. `make book`
  builds the additional book-layout
  showcase `tmdoc4r-tutorial-book.html` / `.pdf` (repo root, untracked,
  illustrative only — never packaged; suggested as a GitHub release asset
  like mndoc's `manual-book-*.pdf`).
- Chunks run through `python3` / `R` / `tclsh` as present on the build
  machine; `make ex` validates the fixtures afterwards.
- **No `VignetteBuilder` field — and none is possible**: tmdoc4r cannot
  build its own vignettes at `R CMD build` time (chicken-and-egg). The
  package instead ships a *pre-built* vignette: the packaged
  `vignettes/tmdoc4r-vignette.Rnw` is a passive Sweave stub
  (`\VignetteIndexEntry` + `\includepdf` of the mndoc PDF) and the
  products live in `inst/doc/tmdoc4r-vignette.{Rnw,pdf}`.
  `R CMD INSTALL` derives `Meta/vignette.rds` from `inst/doc` alone (a
  full `R CMD build` additionally writes `build/vignette.rds`, which is
  not required). **A tarball with an empty `inst/doc` therefore installs
  without a vignette index** and `vignette("tmdoc4r-vignette")` reports
  "not found" — which is what the first v0.6.0 and the v0.5.3 release
  assets shipped; both were replaced with their CI full builds on
  2026-11-04 (see *Replacing a release asset* below), and the `build`
  target now seeds `inst/doc` after its build attempt so the TeX-less
  `--no-build-vignettes` fallback cannot regress. Verify any release
  candidate with a fresh install + `vignette()` before attaching it.

## Version bumps

1. `tmdoc4r-src.R`: `#' Version:` + `#' Date:` (DESCRIPTION section) and a
   `NEWS` entry.
2. Vignette title `tmdoc4r <version> vignette` and `date:` header.
3. If tmdoc/mndoc released: update `inst/tmdoc/lib` (see above).
4. Regenerate, `make build pkg=tmdoc4r`, verify the tarball version and
   that its vignette PDF matches the freshly generated one, then release on
   GitHub (the README vignette badge points at
   `releases/latest/download/tmdoc4r-vignette.pdf`, so attach the PDF).
   Prefer the **CI-built** `tmdoc4r_<version>.tar.gz` artifact (full build,
   includes `build/vignette.rds`); the local `--no-build-vignettes`
   fallback tarball is equally installable — but check *every* candidate
   with a fresh `R CMD INSTALL` + `vignette("tmdoc4r-vignette")` before
   uploading it (the v0.6.0 release initially got a tarball without
   `inst/doc`).

### Replacing a release asset with the CI build

If a defective tarball was already attached (both the v0.6.0 and v0.5.3
assets were, on 2026-11-04), do not rebuild by hand — pull the artifact
of the green CI run for the release commit:

```sh
gh run list --commit <release-commit-sha>          # pick the green run
gh run download <run-id> -n tmdoc4r_<version>.tar.gz -D /tmp/art
R CMD INSTALL -l /tmp/lib /tmp/art/tmdoc4r_<version>.tar.gz
R_LIBS=/tmp/lib Rscript -e 'library(tmdoc4r); vignette("tmdoc4r-vignette")'
gh release upload <tag> /tmp/art/tmdoc4r_<version>.tar.gz --clobber
```

Then re-download the asset from the release and repeat the install check
(closed loop), and append an *Asset note* line to the release body.
Caveat: the tag may sit one workflow-only commit away from the run's
commit — check `git diff <tag> <run-sha>` first (for v0.5.3 that diff was
`.github/workflows/r.yml` only, so the artifact was package-identical).

## Known issues and pitfalls

- **Generated-tree edits vanish**: `make build` removes and recreates
  `tmdoc4r/`; edit `tmdoc4r-src.R` only.
- **`--process` alone leaves `inst/` out** of the tree — run `--vignettex`
  too (see Repository model).
- **Markdown 1.2.5 must not be synced down** to tmdoc's 1.2.4 pin (table
  fix, see Bundled runtime).
- The package-build wrapper may return success **after** `R CMD build`
  failed (the failure is swallowed). `make build` now deletes the current
  tarball up front, so the following `--check` skips instead of silently
  re-checking a stale archive — still verify that a *fresh* tarball was
  produced before using or uploading it.
- A tarball built with `--no-build-vignettes` from a tree whose `inst/doc`
  is empty installs **without** a vignette index (`vignette()` → "not
  found"). The `build` target seeds `inst/doc` for you; when building by
  hand, copy `vignettes/tmdoc4r-vignette.{Rnw,pdf}` into `inst/doc/`
  first. See The vignette.
- The vignette TOC needs its two-pass sequence; a single run embeds a
  stale/empty TOC.
- `exec/tmdoc4r` (bash wrapper) still rejects non-HTML outputs
  ("currently only HTML output is supported!") although `tmdoc()` itself
  can write `.pdf`.
- `R/tmdoc4r.R` `.onLoad` uses `tcltk::.Tcl` — packages without tcltk
  (rare Linux builds, macOS without XQuartz) fail at load.
- Keep generated/build artifacts out of commits: `tmdoc4r/`,
  `tmdoc4r.Rcheck/`, `tmdoc4r_*.tar.gz`, `tmdoc4r-examples.Rmd`, the root
  previews (`tmdoc4r-vignette.*`, `tmdoc4r-tutorial-book.*`), `*.toc`, the weave outputs under `examples/`
  (`ex-*.md`, `ex-11.toc`, `chunk-shell-*.{png,svg,txt,abc}`,
  `fff001.svg`, `examples/images/`), and build residue `temp/`, `images/`,
  `kroki/`, `r-images/`, `pyexample.svg`, `hello.Rmd`, `infile.Rmd`.
  `examples/lipsum.txt` is the exception — it is a required **input**,
  keep (and commit) it.
- The checked-in `examples/*.html` fixtures inline `examples/tmdoc.css`
  as a base64 `<style>` blob — after editing that stylesheet run `make ex`
  or the fixtures silently keep the old rules (they did until 2026-11-03).
- `make ex` output reflects the local toolchain: missing `abcm2ps` or
  `examples/lipsum.txt` does not fail the run loudly but degrades the
  fixtures (external broken `<img>`, embedded `Error:` texts). Diff
  regenerated fixtures against the previous ones before keeping them.
- The `tmdoc4r-src.R` debug leftovers (`print("here")`, `print(fin)` in
  the code-extraction branch of `tmdoc()`) are pre-existing noise — remove
  only if deliberately cleaning up.

## Environment facts (this machine, 2026-11-03)

- Fedora 43; R 4.5.3, `tcltk` available; system `tclsh` is Tcl 9.0.
- `~/.local/bin/tmdoc` = 0.21.1, `~/.local/bin/mndoc` = 0.17.0 (refreshed
  via the official installer on 2026-11-03).
- `chromium-browser` and `weasyprint` installed → both mndoc PDF engines
  available (browser engine chosen, MathJax renders).
- TeX Live 2023 is a system install **without dpkg** and there is no root:
  `pdfpages.sty` (texlive-latex-extra) and `ecrm1000.tfm`
  (texlive-fonts-recommended) are missing, so a full `make build`
  (`R CMD build` Sweave step) and the check's manual PDF fail locally —
  use the `--no-build-vignettes` / `--ignore-vignettes --no-manual`
  fallback from Commands. CI installs the full TeX set; its
  `ubuntu-22.04` runners ship a real `chromium-browser`, so the vignette
  PDF step works there.
- `abcm2ps` 8.14.15 installed user-locally 2026-11-03
  (`~/.local/opt/abcm2ps` + symlink `~/.local/bin/abcm2ps`, from
  `dnf download` + `rpm2cpio`) — needed by `make ex` for `ex-09`.
- Python 3 with matplotlib for the vignette plot example.
