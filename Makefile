##-*- makefile -*-############################################################
#
# Copyright (C) 2025 MicroEmacs User.
#
# All rights reserved.
#
# Synopsis:    
# Authors:     MicroEmacs User
#
##############################################################################

CURRENT_MAKEFILE := $(lastword $(MAKEFILE_LIST))

## argument delegation
ARGS=

## default: list existing tasks 
pkg=tmdoc4r
VERSION=$(shell grep -Eo "^#' Version: [.0-9]+" $(pkg)-src.R | sed -E 's/.+: //g; s/ //g;')
help:
	@printf "Usage:\n"
	@printf "   make build   pkg=sbi\n      for creating a true R package file named sbi_§(VERSION).tar.gz\n" 
	@printf "   make install pkg=sbi\n      for installing the package file sbi_$(VERSION).tar.gz\n"
build:
	-rm -rf $(pkg)/
	Rscript $(pkg)-src.R --process $(pkg)-src.R
	Rscript $(pkg)-src.R --vignettex $(pkg)-src.R
	mv $(pkg)/vignettes temp
	mkdir $(pkg)/inst/doc
	tmdoc tmdoc4r-examples.Rmd - | mndoc - $(pkg)/inst/doc/$(pkg)-examples.html
	tmdoc tmdoc4r-vignette.Rmd - | mndoc - $(pkg)/inst/doc/$(pkg)-vignette.html	
	R_LIBS=`pwd`/$(pkg).Rcheck/ Rscript $(pkg)-src.R --build $(pkg)
	R_LIBS=`pwd`/$(pkg).Rcheck/ Rscript $(pkg)-src.R --check $(pkg)_$(VERSION).tar.gz

install: build	
	Rscript $(pkg)-src.R --install $(pkg)_$(VERSION).tar.gz

clean:
	-rm -rf $(pkg)/
	-rm -rf $(pkg).Rcheck
	
