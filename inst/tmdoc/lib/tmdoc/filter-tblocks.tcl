#!/usr/bin/env tclsh
##############################################################################
#
# Copyright (C) 2026 Detlef Groth, University of Potsdam
#
#
# Synopsis:    Filter for the tmdoc application and package
#
##############################################################################

package require tblocks
namespace eval tmdoc { } 
namespace eval tmdoc::tblocks {
    proc filter {cont dict} {
        set def [dict create results hide eval true include true \
                 fig.path images fig true ext svg fig.width 800]
        set dict [dict merge $def $dict]
        if {![dict get $dict eval]} {
            return [list "" ""]
        }
        set owd [pwd] 
        set fname [file join $owd [dict get $dict fig.path] [dict get $dict label]].svg
        if {![file isdirectory [dict get $dict fig.path]]} {
            file mkdir [dict get $dict fig.path]
        }
        if {[catch {
             set width [dict get $dict fig.width]
             set mdfile [file join $owd [dict get $dict fig.path] [dict get $dict label]].md
             set out [open $mdfile w 0600]
             puts $out "$cont"
             close $out
             tblocks::main [list $mdfile $fname]
             if {$ext in [list .pdf .png]} {
                 if {[auto_execok cairosvg] eq ""} {
                     error "Conversion to $ext needs the cairosvg tool!"
                 }
             } elseif {$ext ne ".svg"}  {
                 error "Unkown file extension, know file extensions are: .svg, .pdf, .png"
             }
             set outfile [regsub {.svg$} $fname $ext]
             if {$ext in [list .pdf .png]} {
                 exec cairosvg $fname -o $outfile -W [expr {($width+20)*$x}] -H 255
                 set fname $outfile
             } 
             set res $cont
         }]} {
            set res "Error: [regsub {\n +invoked.+} $::errorInfo {}]"
        }

        if {[dict get $dict results] eq "hide"} {
            set res ""
        }
        if {![dict get $dict fig]} {
            set fname ""
        } else {
            set res ""
        }
        return [list $res $fname]
    }
}



