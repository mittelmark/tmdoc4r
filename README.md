# tmdoc4r

Lightweight alternative for Knitr/RMarkdown to do literate programming.
This R package is a R version of the Tcl application [tmdoc](https://github.com/mittelmark/tmdoc).

This package supports the following programming and Markup languages.

Programming languages:

- Julia
- Octave
- Python 3
- R
- Tcl

with fenced code blocks and inline single backtick code evaluations.

Markup Languages:

- Markdown, Quarkdown
- Typst
- AsciiDoc
- LaTeX

Features:

- Shell code emmbedding using terminal tools (Music sheets, Diagrams, ...)
- include other files 
- abbreviations based on YAML header and external YAML files
- kroki diagram support
- references using BibTeX files
- CSV data display as tables
- alert messages
- embedding LaTeX equations as images

## INSTALLATION

The package should be installed in an interactive R session like this:

```
install.packages(
  "https://github.com/mittelmark/tmdoc4r/releases/download/v0.1.1/tmdoc4r_0.1.1.tar.gz",
  repos=NULL);
```

Thereafter you can load the package and the vignette of the package like this:

```
library(tmdoc4r)
vignette("tmdoc4r-vignette")
```

## Examples

Here a link to some examples:

http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/modules/examples/ex-01.html

| Description    | Code    | HTML output |
|:---------------|:-------:|:----------:|
| Simple example | [ex-01.tmd](examples/ex-01.tmd) | [ex-01.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-01.html)
| Tcl example    | [ex-02.tmd](examples/ex-02.tmd) | [ex-02.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-02.html)
| R example      | [ex-03.Rmd](examples/ex-03.Rmd) | [ex-03.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-03.html)
| Python example | [ex-04.pmd](examples/ex-04.pmd) | [ex-04.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-04.html)
| Octave example | [ex-05.omd](examples/ex-05.omd) | [ex-05.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-05.html)
| Kroki example  | [ex-06.tmd](examples/ex-06.tmd) | [ex-06.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-06.html)
| Abbreviations  | [ex-07.tmd](examples/ex-07.tmd) | [ex-07.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-07.html)
| CSV tables     | [ex-08.tmd](examples/ex-08.tmd) | [ex-08.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-08.html)
| Shell commands | [ex-09.tmd](examples/ex-09.tmd) | [ex-09.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-09.html)
| LaTeX Math     | [ex-10.tmd](examples/ex-10.tmd) | [ex-10.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-10.html)
| TOC and Includes | [ex-11.tmd](examples/ex-11.tmd) | [ex-11.html](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc4r/blob/master/examples/ex-11.html)

## Author and Copyright


Detlef Groth, University of Potsdam, Germany

## License

```
BSD 3-Clause License

Copyright (c) 2025, Detlef Groth

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
