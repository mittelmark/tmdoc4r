#!/usr/bin/env Rscript
#' FILE: tmdoc4r/DESCRIPTION
#' Package: tmdoc4r
#' Type: Package
#' Title: R single file dummy package
#' Version: 0.1.6
#' Date: 2025-11-12
#' Author: Detlef Groth
#' Authors@R: c(person("Detlef","Groth", role=c("aut", "cre"),
#'                   email = "dgroth@uni-potsdam.de",
#'                   comment=c(ORCID="0000-0002-9441-3978")))
#' Maintainer: Detlef Groth <dgroth@uni-potsdam.de>
#' Description: 
#'    This is lightweight package to perform literate programming with R,
#'    Julia, Python, Octave, Tcl or diagram tools like GraphViz or PlantUML.
#' URL:  https://github.com/mittelmark/tmdoc4r
#' BugReports: https://github.com/mittelmark/tmdoc4r/issues
#' Depends: R (>= 3.5.0)
#' License: MIT + file LICENSE
#' Language: en-US
#' Encoding: UTF-8
#' NeedsCompilation: no
#' Collate: tmdoc4r.R tmdoc.R df2md.R lipsum.R ttangle.R

#' FILE: tmdoc4r/LICENSE
#' YEAR: 2025
#' COPYRIGHT HOLDER: Detlef Groth

#' FILE: tmdoc4r/NEWS
#' 2025-11-06: version 0.1.6 - fixing for inline r code supporting more than one number or word
#' 2025-11-06: version 0.1.5 - fixing issue with spaces around = in code chunk options and
#'                             ignoring headers in the YAML and in code chunk sections for TOC
#' 2025-11-05: version 0.1.4 - fixing fixing issues with single quotes in code chunk arguments 
#'                             and width=0 settings if fig=true in R code chunk
#' 2025-11-04: version 0.1.3 - adding tmdoc.css as example, toc support
#' 2025-11-03: version 0.1.2 - mtex figure width fix, and fix toc for HTML
#' 2025-11-03: version 0.1.1 - vignette fix (pdf file)
#' 2025-11-03: version 0.1.0 - public release
#' 2025-10-29: version 0.1.0 - startig tmdoc4r
#' 2025-10-16: Version 0.0.4 - Fixes for tag backgrounds in vignette stylesheet
#' 2025-09-12: Version 0.0.3 - Support for images at the end of example block with %## ![](`r imgname`)
#' 2025-07-12: Version 0.0.2 - Support for inst folder
#' 2024-08-28: Version 0.0.1 - Initial Release

#' FILE: tmdoc4r/NAMESPACE
#' exportPattern("^[[:lower:]]+")
#' importFrom("stats", "sd")

#' FILE: tmdoc4r/inst/files/decathlon.tab
#' 100	long	shot	high	400	110	disq	pole	jave	1500
#' 1	32	7.43	15.48	2.27	29.4479	26.1732	49.28	4.7	61.32	20.0781
#' 2	33.1187	7.45	14.97	1.97	30.1824	27.3859	44.36	5.1	61.76	19.7788
#' 3	32.2004	7.44	14.2	1.97	29.8198	26.7387	43.66	5.2	64.16	20.5167
#' 4	33.8983	7.38	15.02	2.03	29.3518	26.9022	44.8	4.9	64.04	18.9401
#' 5	32.6679	7.43	12.92	1.97	30.3541	27.5	41.2	5.2	57.46	21.0411
#' 6	33.241	7.72	13.58	2.12	29.789	27.9267	43.06	4.9	52.18	19.703
#' 7	32.2004	7.05	14.12	2.06	29.1852	27.5191	41.68	5.7	61.6	18.544
#' 8	32.5792	6.95	15.34	2	29.8693	27.5766	41.32	4.8	63	20.3114
#' 9	32.287	7.12	14.52	2.03	29.2981	27.0123	42.36	4.9	66.46	20.0282
#' 10	32.057	7.28	15.25	1.97	29.6296	26.8293	48.02	5.2	59.48	18.478
#' 11	32.9068	7.45	15.34	1.97	28.8346	27.7895	41.86	4.8	66.64	18.25
#' 12	32.2004	7.34	14.48	1.94	29.3758	26.2078	42.76	4.7	65.84	21.033
#' 13	32.6679	7.29	12.92	2.06	29.8569	26.506	39.54	5	56.8	20.9424
#' 14	32.7571	7.37	13.61	1.97	30.1066	26.9388	43.88	4.3	66.54	20.0766
#' 15	32.6383	7.45	14.2	1.97	29.4238	25.6477	41.66	4.7	64	20.1884
#' 16	32.4617	7.08	14.51	2.03	28.8635	26.793	43.2	4.9	57.18	20.1087
#' 17	31.4136	6.75	16.07	2	28.0811	24.6575	50.66	4.8	72.6	17.856
#' 18	31.115	7	16.6	1.94	28.8925	26.4	46.66	4.9	60.2	18.8785
#' 19	32.5203	7.04	13.41	1.94	30.0188	26.4706	40.38	4.5	51.5	20.5785
#' 20	33.0579	7.07	15.84	1.79	28.9855	25.7477	45.32	4.9	60.48	19.4356
#' 21	31.25	7.36	13.93	1.94	28.8058	25.3197	38.82	4.6	67.04	20.2687
#' 22	31.3316	7.02	13.8	2.03	28.4585	26.0184	39.08	4.7	60.92	20.5378
#' 23	31.6344	7.08	14.31	2	28.6624	26.4529	46.34	4.4	55.68	19.8034
#' 24	31.8584	6.97	13.23	2.15	28.8115	25.7477	38.72	4.6	54.34	19.4356
#' 25	32.7273	7.23	13.15	2.03	28.9564	26.4706	38.06	4.5	52.82	18.9095
#' 26	31.7741	6.83	11.63	2.06	29.7705	25.731	37.52	4.6	55.42	19.9948
#' 27	32.4324	6.98	12.69	1.82	29.6114	26.1732	38.04	4.7	49.52	20.6186
#' 28	31.2772	7.01	14.17	1.94	28.147	26.087	45.84	4.6	56.28	17.8118
#' 29	31.9716	6.9	12.41	1.88	29.8507	25.3684	38.02	4.4	52.68	19.8486
#' 30	31.3043	7.09	12.94	1.82	29.2267	25.4499	42.32	4.5	53.5	18.3767
#' 31	31.4961	6.22	13.98	1.91	28.0976	24.937	46.18	4.6	57.84	18.3057
#' 32	31.3862	6.43	12.33	1.94	28.6282	26.4	38.72	4	57.26	18.3849
#' 33	31.115	7.19	10.27	1.91	28.3968	24.4444	34.36	4.1	54.94	20.0015

#' FILE: tmdoc4r/man/tmdoc4r-package.Rd
#' \name{tmdoc4r-package}
#' \alias{tmdoc4r-package}
#' \title{The tmdoc4r-package - methods for literate programming with R, Python, Octave and Tcl}
#' \description{
#' The tmdoc4r package contains methods to do literate programming with R in 
#' a similar way like you work with the knitr or Rmarkdown packages.
#' }
#' \details{
#' This is lightweight alternative to the packages knitr or rmarkdown as it only requires the
#' the tcltk package installed which should be present on all platforms per default, except probably
#' on MacOS where this package can be installed together with the XQuartz tools.
#' \describe{
#' \item{\link[tmdoc4r:df2md]{df2md}}{Display a data frame or a matrix in an HTML document}
#' \item{\link[tmdoc4r:lipsum]{lipsum}}{Display some lipsum text}
#' \item{\link[tmdoc4r:tmdoc]{tmdoc}}{function to process Rmd or Tmd input file to Markdown or HTML}
#' }
#' }
#' \examples{
#' library(tmdoc4r)
#'  cat("## Hello\n\n```{r}\nprint('Hello World!')\n```\n",file="infile.Rmd")
#'  tmdoc("infile.Rmd","outfile.html")
#' } 
#' \author{Detlef Groth, University of Potsdam}

#' FILE: tmdoc4r/R/tmdoc4r.R
## tmdoc4r-environment

.onLoad <- function(libname, pkgname) {
    # to show a startup message
    tcltk::.Tcl(paste("lappend auto_path",file.path(system.file(package="tmdoc4r"),"tmdoc", "lib")))
    tcltk::.Tcl("package require tmdoc")
    tcltk::.Tcl("package require mndoc")    
    tools::vignetteEngine("tmdoc4r",
                          package=pkgname,
                          weave = function (file, ...) { tmdoc(file,...,mathjax=TRUE) },
                          tangle=function (file, ...) { ttangle(file,...) },
                          pattern="[.][PpTtRr]md$")
}


#' FILE: tmdoc4r/man/tmdoc.Rd
#' \name{tmdoc}
#' \alias{tmdoc}
#' \title{perform literate programming}
#' \description{
#' Convert Markdown documents with R, Python, Octave or Diagram code to HTML output.
#' }
#' \usage{ tmdoc(infile, outfile=NULL, css=NULL, quiet=FALSE, mathjax=NULL, refresh=NULL, inline=TRUE, toc=FALSE, ...) }
#' \arguments{
#'   \item{infile}{
#'     an infile with Markdown code and embedded Programming language code
#'   }
#'   \item{outfile}{
#'     an HTML outfile, if not given the Markdown extension is simply exchanged by html, default: NULL
#'   }
#'   \item{css}{
#'     an optional css file, default: NULL
#'   }
#'   \item{quiet}{
#'     should messages been hidden, default: FALSE
#'   }
#'   \item{mathjax}{
#'     should the MathJax Javascript library be loaded, default: NULL
#'   }
#'   \item{refresh}{
#'     should the HTML be refreshed every N seconds, values lower than 10 means no refreshment, default: NULL
#'   }
#'   \item{inline}{
#'     should images and css files beeing inlined into the final HTML document to make it standalone, 
#'     if not given or called with inline=TRUE,they are inlined, default: TRUE
#'   }
#'   \item{toc}{
#'     should be a TOC file generated which can be included in the current document, 
#'     using the `tcl include filename.toc` syntax, default: FALSE
#'   }
#'   \item{\ldots}{kept for compatibility with tmdoc, not used currently }
#' }
#' \details{
#' This function allows you to perform literate programming where you embed R, Python, Octave or Tcl code
#' into your Markdown documents and convert them later to HTML output. Beside of programming languages as 
#' well embedding shell programs, or diagram code for GraphViz or PlantUML can be embedded if the appropiate
#' tools are available. For a list of available tools which can be used see \url{https://github.com/mittelmark/tmdoc}.
#'
#' The package can be seen as a lightweight alternative to the rmarkdown or knitr packages. In contrast to them you have 
#' embed plots using the \code{png} and the \code{dev.off} commands within your Rmd document and then you use Markdown image syntax
#' after the code block to embed the image. 
#' }
#' \examples{
#' print("tmdoc running")
#' ## equation and R example:
#' md="`tcl include hello.toc`\n\n"
#' md=paste(md,"## Title\n\nHello World!\n\n## Equation examples\n\n",sep="")
#' md=paste(md,"This is an inline equation: $ E = mc^2 $\n",sep="")
#' md=paste(md,"\nAnd this is a block equation: \n$$x = {-b \\\\pm \\\\sqrt{b^2-4ac} \\\\over 2a}.$$\n\n",sep="")
#' md=paste(md,"\n\n## R Code Example\n\n```{r eval=TRUE}\nprint('Hello World!')\n```\n",sep="")
#' ## Tcl example
#' md = paste(md, "\n## Tcl Code example\n\n```{.tcl eval=TRUE}\nset x 1\nputs $x\n```\n\n")
#' ## Kroki Diagram example
#' md = paste(md, "\n##Kroki Diagram example\n\n```{.kroki eval=TRUE,dia=\"graphviz\"}\n",sep="")
#' md = paste(md,"digraph g {  rankdir=\"LR\"\n  node[style=filled,shape=box,fillcolor=salmon]\n",sep="")
#' md = paste(md,"A -> B -> C\n}\n```\n\n",sep="")
#' cat(md,file="hello.Rmd")
#' tmdoc("hello.Rmd","hello.html",refresh=10,mathjax=TRUE)
#' tmdoc("hello.Rmd","hello.html",refresh=10,mathjax=TRUE,
#'  css=file.path(system.file(package="tmdoc4r"),"files", "tmdoc.css"),
#'  toc=TRUE)
#' ## we run it twice to get a real TOC
#' tmdoc("hello.Rmd","hello.html",refresh=10,mathjax=TRUE,
#'  css=file.path(system.file(package="tmdoc4r"),"files", "tmdoc.css"),
#'  toc=TRUE)
#' #file.remove("hello.Rmd")
#' #file.remove("hello.html")
#' }

#' FILE: tmdoc4r/R/tmdoc.R
tmdoc <- function (infile, outfile=NULL, css=NULL, quiet=FALSE, mathjax=NULL, refresh=NULL, inline=TRUE, toc=FALSE,...) {
    stopifnot(file.exists(infile))
    mdfile=gsub("\\..md$",".md",infile)
    if (is.null(outfile)) {
        outfile=gsub("\\..md$",".html",infile)
    } 
    if (is.null(css)) {
        css=""
    } else {
        css=paste("--css",css)
    }
    if (toc) {
        tocx="--toc true"
    } else {
        tocx = ""
    }
    if (is.null(mathjax)) {
        mjx=""
    } else {
        mjx="--mathjax true"
    }
    if (is.null(refresh)) {
        refresh=""
    } else {
        refresh=paste("--refresh",refresh)
    }
    if (inline) {
        inline="--base64 true"
    } else {
        inline="--base64 false"
    }
    cmdline = paste("set ::argv [list",infile, mdfile,tocx,"]")        

    tcltk::.Tcl("set ::quiet true")
    tcltk::.Tcl(paste(paste("cd",getwd())))
    tcltk::.Tcl("if {[info commands ::exitorig] eq {}} {  rename ::exit ::exitorig ; }; proc ::exit {args} { return }")
    tcltk::.Tcl(cmdline)
    tcltk::.Tcl("set ::argv0 tmdoc")
    tcltk::.Tcl("tmdoc::main $argv")
    cmdline = paste("set ::argv [list",mdfile,outfile,mjx,css,refresh,inline,"]")
    tcltk::.Tcl(cmdline)
    tcltk::.Tcl("set ::argv0 mndoc")
    tcltk::.Tcl("mndoc::main $argv")
    if (!quiet) {
        message(paste("Processing",infile,"to",outfile,"done!"))
    }
}

#' FILE: tmdoc4r/man/ttangle.Rd
#' \name{ttangle}
#' \alias{ttangle}
#' \title{ extract code chunks }
#' \description{
#' A function which extracts code chunks from Markdown documents.
#' }
#' \usage{ ttangle(infile, outfile=NULL, type="r",quiet=FALSE,...) }
#' \arguments{
#'   \item{infile}{
#'     an infile with Markdown code and embedded Programming language code
#'   }
#'   \item{outfile}{
#'     a script outfile, if not given the Markdown extension is simply exchanged by the type, default: NULL
#'   }
#'   \item{type}{
#'     an optional chunk type to be extractted, default: "r"
#'   }
#'   \item{quiet}{
#'     should messages been hidden, default: FALSE
#'   }
#'   \item{\ldots}{kept for compatibility with pandoc, not used currently}
#' }
#' \details{
#'     Some more details ...
#' }
#' \examples{
#' print("tmdoc4r::ttangle running")
#' cat("## Title\n\nHello World!\n\n```{r eval=TRUE}\nprint('Hello World!')\n```\n",file="hello.Rmd")
#' ttangle("hello.Rmd","hello.R")
#' #file.remove("hello.Rmd")
#' #file.remove("hello.R")
#' }

#' FILE: tmdoc4r/R/ttangle.R
ttangle <- function(infile, outfile=NULL,type="r",quiet=FALSE,...) {
    stopifnot(file.exists(infile))
    if (is.null(outfile)) {
        outfile=gsub("\\..md",paste(".",type,sep=""),infile)
        outfile=gsub(".r$",".R$",outfile)
    }
    fin  = file(infile, "r")
    fout = file(outfile,'w')
    flag = FALSE
    regex=paste('^>? ?```\\{',type,sep="")
    while(length((line = readLines(fin,n=1)))>0) {
        if (flag && grepl(regex,line)) {
            flag = FALSE
        } else  if (grepl(regex,line)) {
            flag = TRUE
        } else if (flag) {
            cat(line,file=fout)
        }
    }
    close(fout)
    close(fin)
    invisible(outfile)
}

#' FILE: tmdoc4r/man/df2md.Rd
#' \name{df2md}
#' \alias{df2md}
#' \title{Convert matrices or data frames into Markdown tables}
#' \description{
#' Utility function to be used within Markdown documents to convert
#' data frames or matrices into Markdown tables.
#' }
#' \usage{df2md(df,caption="",rownames=TRUE) }
#' \arguments{
#'   \item{df}{ data frame or matrix}
#'   \item{caption}{table caption, shown below of the table, default: ""}
#'   \item{rownames}{should rownames been show, default:TRUE}
#' }
#' \details{
#'     Some more details ...
#' }
#' \examples{
#' df2md(head(iris),caption="iris data")
#' }

#' FILE: tmdoc4r/R/df2md.R

df2md <- function(df,caption="",rownames=TRUE) {
    cn <- colnames(df)
    if (is.null(cn[1])) {
        cn=as.character(1:ncol(df))
    }
    rn <- rownames(df)
    if (is.null(rn[1])) {
        rn=as.character(1:nrow(df))
    }
    if (rownames) {
        headr <- paste0(c("","", cn),  sep = "|", collapse='')
        sepr <- paste0(c('|', rep(paste0(c(rep('-',3), "|"), 
                                         collapse=''),length(cn)+1)), collapse ='')
    } else {
        headr <- paste0(c("", cn),  sep = "|", collapse='')
        sepr <- paste0(c('|', rep(paste0(c(rep('-',3), "|"), 
                                         collapse=''),length(cn))), collapse ='')
        
    }
    st <- "|"
    for (i in 1:nrow(df)){
        if (rownames) {
            st <- paste0(st, "**",as.character(rn[i]), "**|", collapse='')
        }
        for(j in 1:ncol(df)){
            if (j%%ncol(df) == 0) {
                st <- paste0(st, as.character(df[i,j]), "|", 
                             "\n", "" , "|", collapse = '')
            } else {
                st <- paste0(st, as.character(df[i,j]), "|", 
                             collapse = '')
            }
        }
    }
    fin <- paste0(c("\n \n ",headr, sepr, substr(st,1,nchar(st)-1)), collapse="\n")
    if (caption!='') {
        fin=paste0(fin,'\n',caption,'\n')
    }
    cat(fin)
}

#' FILE: tmdoc4r/man/lipsum.Rd
#' \name{lipsum}
#' \alias{lipsum}
#' \title{Create lipsum text to fill documents with text blocks}
#' \description{
#' This function allows you to fill simple Lorem lipsum text into your document
#' to start initial layout previews.
#' }
#' \usage{lipsum(type=1, paragraphs=1,lang="latin") }
#' \arguments{
#'    \item{type}{the lipsum block, either 1 (Lorem lipsum ...) or 2 (Sed ut perspiciatis ...), default: 1}
#'    \item{paragraphs}{integer, how many paragraphs, default: 1}
#'    \item{lang}{either 'latin' or 'english', the latter is not yet implemented, default: 'latin'}
#' }
#' \examples{
#' cat(lipsum(1,paragraphs=2))
#' }

#' FILE: tmdoc4r/R/lipsum.R
lipsum <- function (type=1, paragraphs=1,lang="latin") {
   if (lang == "latin") {
       if (type == 1) {
           lips=paste(rep("Lorem ipsum dolor sit amet, consectetur adipiscing elit,
                          sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                          Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
                          nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
                          reprehenderit in voluptate velit esse cillum dolore eu fugiat
                          nulla pariatur. Excepteur sint occaecat cupidatat non proident,
                          sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n",paragraphs),collapse="\n")
       } else if (type == 2) {
           lips=paste(rep("Sed ut perspiciatis unde omnis iste natus error sit voluptatem
                          accusantium doloremque laudantium, totam rem aperiam, eaque ipsa
                          quae ab illo inventore veritatis et quasi architecto beatae vitae
                          dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas
                          sit aspernatur aut odit aut fugit, sed quia consequuntur magni
                          dolores eos qui ratione voluptatem sequi nesciunt. Neque porro
                          quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur,
                          adipisci velit, sed quia non numquam eius modi tempora incidunt
                          ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim
                          ad minima veniam, quis nostrum exercitationem ullam corporis
                          suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?
                          Quis autem vel eum iure reprehenderit qui in ea voluptate velit
                          esse quam nihil molestiae consequatur, vel illum qui dolorem eum
                          fugiat quo voluptas nulla pariatur?\n\n",paragraphs),collapse="\n")
       } else {
         stop("only type 1 and 2 are supported")
      } 
   } else {
      stop("Only latin supported currently")
   }
   lips=gsub("  +", " ",lips)
   return(lips)
}

#' FILE: EOF

VIGNETTE = "---
title: %s tutorial
author: NN
date: %s 00:00
output:
   html_document:
      toc: true
      theme: null
      css: mini.css
   %%\\VignetteEngine{knitr::rmarkdown}
   %%\\VignetteIndexEntry{%s tutorial}
include-before: |
    <style>
    @import url(https://fonts.bunny.net/css?family=andika:400,400i,700,700i|ubuntu-mono:400,400i,700,700i);
    font-family: 'Andika', sans-serif;
    font-family: 'Ubuntu Mono', monospace;
    body {
        padding: 30px;
        max-width: 1000px;
        margin: 0 auto;
    }
    pre, blockquote pre, #TOC {
        font-size: 90%%;
        border-top:    0.1em #9ac solid;
        border-bottom: 0.1em #9ac solid;
        padding: 10px;
        background: #e9f9ff;
    }
    #TOC ul, #TOC ul li, #TOC ul li a,
    code, .hljs-literal, .hljs-number, .hljs-comment, .hljs-keyword, .hljs-string {  background: #e9f9ff; }
    table { min-width: 400px; border-spacing: 5px;  border-collapse: collapse; }
    .title, .author, .date { text-align: center ; }
    #TOC > ul { margin-left: -20px;  list-style-type: square ; }
    a { color: #0655cc; text-decoration: none; }
    a:visited { color: #5506cc; }
    a:hover { color: #cc5506; }    
    table {    
        border-collapse: collapse;
        border-bottom: 2px solid;
        border-spacing: 5px;
        min-width: 400px;
    }
    table thead tr th { 
        background-color: #fde9d9;
        text-align: left; 
        padding: 10px;
        border-top: 2px solid;
        border-bottom: 2px solid;
    }
    table td { 
        background-color: #fff9e9;

        text-align: left; 
        padding: 10px;
    }
    table td strong { background-color: #fff9e9; }
    p code { background: #f1f7fa ; font-size: 90%%;}
    </style>
    <center>some links on top</center>
---

## Introduction

"

USAGE = "
Usage:
=====
  %s [OPTIONS] [PKGNAME|SRCFILE|PKGDIR|RDFILE|PKGFILE]

  OPTIONS

    --help                 - show this help page%s
    --process      SRCFILE - create package structure from the given
                             R package source file
                             
    --build        PKGDIR  - build a package from the given package dir
    --check        PKGFILE - check the given package file (tar.gz file)
    --check-man    PKGDIR  - check the created Rd files from the package
    --doc          RDFILE  - preview an Rd file usually from the man folder
    --vignettex    SRCFILE - extract the examples as R-Markdown document to
                             to pkg/vignettes/pkg-examples.Rmd    
    --install      PKGFILE - install the given package file (tar.gz file)
    
  ARGUMENTS
  
    PKGNAME - the name of a new package, name should only consist of
              letters and numbers
    SRCFILE - a R package source file like sbi-src.R
    PKGDIR  - the directory containing the package files created
    RDFILE  - a documentation file in R-Docu format (Rdoc)
    PKGFILE - the package tar.gz file made from the --build argument
    
  AUTHOR
  
    Detlef Groth, University of Potsdam  
    
  HELP     
  
    Use the issue tracker at Github https://github.com/mittelmark/rsfp/issues
  
  LICENSE and COPYRIGHT
  
    Copyright : 2024 - Detlef Groth, University of Potsdam  
    License   : See the file LICENSE
    
    
"
NP="
    --new-package  PKGNAME - create a new PKGNAME-src.R file
"

CheckRd <- function (pkg) {
    pwd=getwd()
    setwd(file.path(pkg,"man"))
    rd_files <- list.files(pattern = "\\.Rd$", full.names = TRUE)
    check_rd_file <- function(file) {
        result <- tools::checkRd(file)
        if (length(result) > 0) {
            return(data.frame(file = file, messages = paste(result, collapse = "; ")))
        }
        return(NULL)
    }
    check_results <- do.call(rbind, lapply(rd_files, check_rd_file))
    if (!is.null(check_results)) {
        print(check_results)
    } else {
        cat("No issues found in the Rd files.\n")
    }
    setwd(pwd)
}

ExtractEx <- function (srcfile) {
    fin  = file(srcfile, "r")
    fout = NULL
    ex = FALSE
    dr = FALSE
    lastindent = 0;
    usage=FALSE
    descr=FALSE
    while(length((line = readLines(fin,n=1)))>0) {
        if (grepl("^#' Package:",line)) {
            pkg = gsub("#' Package: +","",line)
            rmdfile=paste(pkg,"-examples.Rmd",sep="")
            fout = file(rmdfile,'w')
            code=gsub("Introduction","EXAMPLES",gsub("tutorial","examples",VIGNETTE))
            cat(sprintf(code,pkg,Sys.Date(),pkg),file=fout)
            if (dir.exists("inst")) {
                if (!dir.exists(file.path(pkg,"inst"))) {
                    dir.create(file.path(pkg,"inst"))
                }
                for (dir in list.dirs("inst",recursive=FALSE)) {
                    cat("Copying dir:",dir,"\n")
                    file.copy(dir,file.path(pkg,"inst"),recursive=TRUE)
                }
            }
            cat("Files from inst folder copied into package folder!\n")
        } else if (grepl("^#' \\\\name",line)) {
            cat(paste("### ",gsub(".+\\{(.+)\\}","\\1",line),"\n"),file=fout)
             name=gsub("[^A-Za-z0-9]","_",gsub(".+\\{(.+)\\}.*","\\1",line))                      
        } else if (grepl("^#' \\\\title",line)) {
            cat(paste("\n\n",gsub(".+\\{(.+)\\}","\\1",line),".\n",sep=""),file=fout)
            ex = FALSE
        } else if (grepl("^#' \\\\usage",line)) {
            if (grepl("^#' \\\\usage\\{.+\\}",line)) {
               cat(paste("\n\n__Usage:__\n\n```\n",gsub(".+\\{(.+)\\}","\\1",line),"\n```\n",sep=""),file=fout)
            } else if (grepl("^#' \\\\usage\\{.+",line)) {
               cat(paste("\n\n__Usage:__\n\n```{r eval=FALSE}\n",gsub(".+\\{(.+)","\\1",line),"\n",sep=""),file=fout)
               usage=TRUE    
            } else if (grepl("^#' \\\\usage\\{",line)) {
               cat(paste("\n\n__Usage:__\n\n```{r eval=FALSE}\n",sep=""),file=fout)
               usage=TRUE    
            }
        } else if (grepl("^#' \\\\description",line)) {
            if (grepl("^#' \\\\description\\{.+\\}",line)) {
               cat(paste("\n\n",gsub(".+\\{(.+)\\}","\\1",line),"\n",sep=""),file=fout)
            } else if (grepl("^#' \\\\description\\{.+",line)) {
               cat(paste("\n\n",gsub(".+\\{(.+)","\\1",line),"\n",sep=""),file=fout)
               descr=TRUE    
            } else if (grepl("^#' \\\\description\\{",line)) {
               cat(paste("\n\n",sep=""),file=fout)
               descr=TRUE    
            }
        } else if ( (usage | descr)  & grepl("^#' .*\\}",line)) {
            if (usage) {                                 
                cat("```\n",file=fout)                     
                usage = FALSE
            } else {
                descr = FALSE
            }
        } else if (usage | descr) {
            cat(gsub("#' ","",line),"\n",file=fout)
        } else if (grepl("^#' \\\\examples",line)) {
            opt=""             
            if (grepl("%options:",line)) {
                opt=gsub(".+%options:","",line)
            }
            if (opt != "") {
                opt=paste(",",opt,sep="")
            }
            cat(sprintf("\n__Examples:__\n\n```{r label=%s%s}\n",name,opt),file=fout)
            ex = TRUE
        } else if (ex & lastindent < 3 & substr(line,1,4) == "#' }") {
            cat("```\n\n",file=fout)                   
            if (grepl("%## !\\[\\].+",line)) {
                cat(gsub(".+## ","",line),file=fout)
                cat("\n\n",file=fout)
            }
            ex = FALSE
        } else if (ex & substr(line,1,11) == "#' \\dontrun") {
            dr = TRUE
        } else if (dr & substr(line,1,5) == "#'  }") {
            dr = FALSE
        } else if (ex) {
            lastindent = nchar(gsub("#'([ ]+).*","\\1",line))
            cat(gsub("\\\\%","%",gsub("#' ", "",line)),file=fout)  
            cat("\n",file=fout)         
        }
    }
    if (class(fout)[1] =="NULL") {
        close(fout)
    }
    close(fin)
    if (!dir.exists(file.path(pkg,"vignettes"))) {
        dir.create(file.path(pkg,"vignettes"))
    }
    file.copy(rmdfile,file.path(pkg,"vignettes",rmdfile),overwrite=TRUE)
    cat(sprintf("File: %s was written\n",file.path(pkg,"vignettes",rmdfile)))
}

Usage <- function (argv) {
    if (!grepl("rsfp-src.",argv[1])) {
        help=sprintf(USAGE,argv[1],"")
    } else {
        help=sprintf(USAGE,argv[1],NP)
    }
    cat(help)
}
Main <- function (argv) {
    VERSION=""
    PACKAGE=""
    if ("--help" %in% argv) {
        Usage(argv)
        
    } else if ("--new-package" %in% argv & length(argv) == 3) {
        if (!grepl("rsfp",argv[1])) {
            cat("Error: Only the file rspf-src.R can be used to create new packages!\n")
            return()
        }
        idx=which(argv=="--new-package") ;
        if (idx != 2) {
            Usage(argv)
        } else {
            new_pkgname = argv[3]
            if (!grepl("^[a-zA-Z][A-Za-z0-9]{2,}$",new_pkgname)) {
                cat("Error: The package name should only consist of numbers and letters!\n")
            } else {
                fin = file(argv[1],'r')
                outname = paste(new_pkgname,"-src.R",sep="")
                if (file.exists(outname)) {
                    cat(sprintf("Error: File '%s' already exists, remove if you like to create a new package!\n",outname))
                    return()
                }
                fout = file(outname,'w')
                main = FALSE
                while(length((line = readLines(fin,n=1)))>0) {
                    if (grepl("^#' +FILE: +EOF",line)) {
                        main = TRUE      
                    } 
                    if (main) {
                        cat(sprintf("%s\n",line),file=fout)
                    } else {
                        cat(sprintf("%s\n",gsub("rsfp",new_pkgname,line)),file=fout)
                    }
                }
                close(fin)
                close(fout)
            }
        }
        if (!file.exists(sprintf("%s-vignette.Rmd",new_pkgname))) {
            fout=file(sprintf("%s-vignette.Rmd",new_pkgname),'w')
            cat(sprintf(VIGNETTE,new_pkgname,Sys.Date(),new_pkgname),file=fout)
            close(fout)
        }
        cat("\nDone!\n\nYou can create a directory structure for your package file like this:\n\n")
        cat(gsub("rsfp",new_pkgname,sprintf("  Rscript %s --process %s\n",argv[1],argv[1])))
    } else if ("--process" %in% argv & length(argv) > 2) {
        idx=which(argv=="--process")
        rfile = argv[idx+1]
        if (!file.exists(rfile)) {
            cat(sprintf("Error: File '%s' does not exists!",rfile))
            return
        }
        fin = file(rfile,'r')
        fout = NULL
        while(length((line = readLines(fin,n=1)))>0) {
            if (grepl("^#' +FILE:",line)) {
                f = gsub("#' +FILE: +([^ ]+) *","\\1",line)
                if (!is.null(fout)) {
                    close(fout)
                    fout = NULL
                }
                if (f == "EOF") {
                    next
                }
                print(paste("creating", f))
                if (grepl(".+/",f)) {
                    d = gsub("(.+)/.+","\\1",f) 
                    if (!dir.exists(d)) {
                        print(paste("creating",d))
                        dir.create(d,recursive=TRUE,showWarnings=FALSE)
                    }
                    fout=file(f,'w') 
                    next
                } else {
                    fout=file(f,'w') 
                }
            } else if (!is.null(fout)) {
                if (grepl("^#' Package:",line)) {
                    PACKAGE=gsub("^#' Package: +([^ ]+) ?.*","\\1",line)
                } else if (grepl("^#' Version:",line)) {
                    VERSION=gsub("^#' Version: +([^ ]+) ?.*","\\1",line)
                }            
                cat(gsub("^#' ?","",line),"\n",file=fout)
           }
        }
        close(fin)
        if (!is.null(fout)) {
            close(fout)
        }
        ## TODO extract 
        ## DESCRIPTION, NAMESPACE, LICENSE, NEWS
        ## extract tests/* files
        ## extract inst/files/* files
        vignette=sprintf("%s-vignette.Rmd",PACKAGE)
        vigdir  = sprintf("%s/vignettes",PACKAGE)
        if (file.exists(vignette)) {
            if (!dir.exists(vigdir)) {
                dir.create(vigdir)
            }
            file.copy(vignette,vigdir)
        }
        cat("\nDone!\n\nYou can create and install a package file like this:\n\n")
        cat(sprintf("  Rscript %s --build     %s\n",argv[1],PACKAGE))
        cat(sprintf("  Rscript %s --check-man %s\n",argv[1],PACKAGE))        
        cat(sprintf("  Rscript %s --check     %s_%s.tar.gz\n",argv[1], PACKAGE, VERSION))
        cat(sprintf("  Rscript %s --install   %s_%s.tar.gz\n\n", argv[1], PACKAGE, VERSION))
    } else if ("--build" %in% argv & length(argv) == 3) {
        library(tools)
        tools::Rcmd(c("build", argv[3]))
    } else if ("--check" %in% argv & length(argv) == 3) {
        library(tools)
        tools::Rcmd(c("check", "--ignore-vignettes",argv[3]))
    } else if ("--install" %in% argv & length(argv) == 3) {
        library(tools)
        tools::Rcmd(c("INSTALL", argv[3]))
    } else if ("--check-man" %in% argv) {s
        CheckRd(argv[3])
    } else if ("--vignettex" %in% argv) {
        ExtractEx(argv[3])
    } else if ("--doc" %in% argv & length(argv) == 3) {
        if (!file.exists(argv[3])) {
            cat(sprintf("Error: File '%s' does not exists!\n",argv[3]))
        } else if (!grepl("Rd$",argv[3])) {
            cat(sprintf("Error: File '%s' is not an Rd file!\n",argv[3]))
        } else {
            cat(tools::Rd2txt(argv[3]))
        }
    } else {
        Usage(argv)
    }
}
if (sys.nframe() == 0L && !interactive()) {
    ## extract application's filename
    binname = gsub("--file=", "", grep("--file", commandArgs(), value=TRUE)[1])
    Main(c(binname,commandArgs(trailingOnly=TRUE)))
    
}
