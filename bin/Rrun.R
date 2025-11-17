#!/usr/bin/env Rscript

usage <- function(argv) {
    cat(sprintf("Rrun PKNAME ?arguments?\n"))
}
main <- function(argv) {
    if (length(argv)>1) {
        if (!requireNamespace(sprintf("%s",argv[2]), quietly=TRUE)) {
            cat(sprintf("Error: Package %s is not installed!\n"))
        } else {
            path=system.file(package=argv[2])
            script = file.path(path,"exec",argv[2])
            if (file.exists(script)) {
                if (length(argv)>2) {
                    system2(script,args=c(argv[3:length(argv)]))
                } else {
                    system2(script)
                }
            } else {
                cat(sprintf("No file '%s' in exec folder of package!",arrgv[2]))
            }
        }
    } else {
        usage(argv)
    }
}
if (sys.nframe() == 0L && !interactive()) {
    binname <- gsub("--file=","", grep("--file", commandArgs(), value=TRUE)[1])
    main(c(binname, commandArgs(trailingOnly=TRUE)))
}

