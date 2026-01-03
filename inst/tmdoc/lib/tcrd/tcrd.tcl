#!/usr/bin/env tclsh
#' ---
#' title: tcrd package - chord sheets and chord display
#' author: Detlef Groth, University of Potsdam, Germany
#' date: 2026-01-01
#' --- 
#'
#' ## NAME 
#'
#' _tcrd_ - Display chord sheet music and music chords for Guitar, Ukulele and
#' other string instruments.
#' 
#' `include tcrd.toc`
#' 
#' ## SYNOPSIS
#'
#' ```
#' package require tsvg
#' package require tcrd
#' tcrd transpose NOTE STEP
#' tcrd chordsheet SONGTEXT
#' tcrd songtranspose SONGTEXT STEP
#' tcrd svgchord NAME CHORDSTRING ARGS
#' ```
#' 
#' ## DESCRIPTION
#'
#' This package allow you to write chord sheets for given lyrics and embedded chords,
#' transpose these chords in halfsteps an as well display chord charts for fretted instruments like
#' Guitar or Ukulele giving fingering positions.
#' 
##############################################################################

#' ## FUNCTIONS
#'

package provide tcrd 0.0.2

namespace eval tcrd {
    namespace export transpose chordsheet svgchords \
          songtranspose
    namespace ensemble create
    #'
    #' __tcrd transpose__ _note half-step_
    #' 
    #' > Low level function to transpose a note by a certain number of half steps
    #'
    #' > _Arguments:_
    #'
    #' > - _note_ - a note like Ab, A, Bb, B, C, ...
    #'   - _step_ - a halfstep like 1, 2, 3, ...
    #' 
    #' > Example:
    #'
    #' ```{.tcl}
    #' package require tcrd
    #' puts [tcrd transpose C 2]
    #' puts [tcrd transpose C 8]
    #' puts [tcrd transpose G 4]
    #' ```
    proc transpose {note step} {
        if {![regexp {^[A-G]} $note]} {
            return $note
        }
        # check for chord
        set note [string map [list A# Bb C# Db D# Eb F# Gb G# Ab] $note]
        set tp [regsub {^[A-G]b?} $note ""]
        set note [regsub {^([A-G]b?).*} $note "\\1"]
        set notes [list Ab A Bb B C Db D Eb E F Gb G]
        set idx [lsearch $notes $note]
        if {$idx == -1} {
            error "Error: Invalid idx=$idx note $note, valid ones are $notes!"
        }
        incr idx $step
        if {$idx < 0} {
            set idx [expr {12+$idx}]
        } elseif {$idx > 11} {
            set idx [expr {$idx-12}]
        }
        return [lindex $notes $idx]$tp
    }
    #'
    #' __tcrd chordsheet__ _song ?transpose-step?_
    #'
    #' > Create chord sheets for lyrics with embedded chords.
    #'
    #' > _Arguments:_
    #'
    #' > - _song_ - song lyrics with embedded chords like 'text [C]text t[Dm]ext'
    #'   - _transpose-step_ - a halfstep like for transposing, default: 0
    #' 
    #' > Example:
    #'
    #' ```{.tcl}
    #' package require tcrd
    #' puts [tcrd chordsheet {text [C]text t[Dm]ext}]
    #' puts [tcrd chordsheet {text [C]text t[Dm]ext} 2]
    #' ```
    proc chordsheet {song {transpose 0}} {
        set nsong  ""
        foreach line [split $song "\n"] {
            set chords ""
            set txt    ""
            if {[regexp {^\s*\[[A-Z0-9][a-z]{3}[ a-z]*\]\s*$} $line]} {
                append nsong "$line\n"
                continue
            }
            if {[regexp {^\s*[^a-zA-Z]+$} $line]} {
                append nsong "$line\n"
                continue
            }
            if {[regexp {^\s*\[[A-H][a-z0-9]*\]\s+-\s+\[[A-H][a-z0-9]*\].+} $line]} {
                set line [regsub -all {[\[\]]} $line ""]
                
                foreach crd [split $line " "] {
                    if {[regexp {^[A-G]} $crd]} {
                        append nsong [transpose $crd $transpose]
                    } else {
                        append nsong $crd
                    }
                    append nsong " "
                }
                append nsong "\n"
                continue
            }
            foreach block [split $line " "] {
                if {[regexp {^\[[-A-Za-z0-9]+\](.+)} $block]} {
                    # [Chord]text
                    set chord [transpose [regsub {\[(.+)\].+} $block "\\1"] $transpose]
                    set word  [regsub {\[.+\](.+)} $block "\\1"]
                    append txt $word
                    append chords $chord
                    set diff [expr {[string length $chord] - [string length $word]}]
                    if {$diff >= 0} {
                        append txt [string repeat " " [expr {$diff+1}]]
                        append chords " "
                    } elseif {$diff < 0} {
                        append chords [string repeat " " [expr {-$diff+1}]]
                        append txt " "
                    }
                } elseif {[regexp {.+\[[-A-Za-z0-9]+\](.+)} $block -> nblock]} {
                    # te[Chord]xt
                    set chord [transpose [regsub {.+\[(.+?)\].+} $block "\\1"] $transpose]
                    set word1  [regsub {(.+)\[.+?\].+} $block "\\1"]
                    set word2  [regsub {.+\[.+?\](.+)} $block "\\1"]                
                    append txt "$word1$word2 "
                    set nchord [string repeat " " [string length $word1]]
                    append nchord $chord
                    set nspaces [expr {[string length $word2] - [string length $chord] + 1}]
                    append nchord [string repeat " " $nspaces]
                    append chords $nchord
                    set block $word2
                    
                } elseif {[regexp {^\[[-A-Za-z0-9]+\]$} $block]} {
                    # [Chord]
                    set chord [transpose [regsub {\[(.+)\]} $block "\\1"] $transpose]
                    append chords "$chord "
                    append txt [string repeat " " [string length $chord]]
                    append txt " "
                } else {
                    # text only
                    set word $block
                    append chords [string repeat " " [string length $word]]
                    append chords " "
                    append txt "$word "
                }
            }
            if {[regexp {[a-zA-Z]} $txt]} {
                append nsong "$chords\n$txt\n"
            } else {
                append nsong "$chords\n"
            }
        }
        return [string trimright $nsong]
    }
    #'
    #' __tcrd songtranspose__ _song transpose-step?_
    #' 
    #' > Transpose the chords of chord sheet where chords are above the lyrics.
    #'
    #' > _Arguments:_
    #'
    #' > - _song_ - song lyrics with chords above the lyrics
    #'   - _transpose-step_ - halfstep used for transposing
    #' 
    #' > Example:
    #'
    #' ```{.tcl}
    #' package require tcrd
    #' puts [tcrd songtranspose {    C     Em
    #' text text text} 2]
    #' ```
    proc songtranspose {song transpose} {
        set nsong  ""
        foreach line [split $song "\n"] {
            if {[regexp { [a-z]{2}} $line] || [regexp {[,?!]} $line] || [regexp {[a-zA-Z][a-z]{4,}} $line]} {
                append nsong "$line\n"
            } else {
                set ochords [split $line " "]
                set nchords [list]
                foreach chrd  $ochords {
                    if {[regexp {^[A-G][#b]?} $chrd letter]} {
                        set tchrd [transpose $letter $transpose]
                        lappend nchords "$tchrd[string range $chrd [string length $letter] end]"
                    } else {
                        # whitespace probably
                        lappend nchords " "
                    }
                }
                set lag 0
                set nline ""
                for {set i 0} {$i < [llength $ochords]} {incr i 1} {
                    set o [lindex $ochords $i]
                    if {$o eq ""} {
                        if {$lag > 0}  {
                            append nline ""
                            incr lag -1
                        } else {
                            append nline " "
                        }
                        continue
                    }
                    set n [lindex $nchords $i]
                    set lag [expr {[string length $n] - [string length $o]}] 
                    if {$lag < 0} {
                        append nline "$n  "
                        set lag 0
                    } else {
                        append nline "$n "
                    }
                }
                append nsong "$nline\n"
            }
        }
        return [string trimright $nsong]
    }
    #'
    #' __tcrd svgchords__ _name cstring ?args?_
    #'
    #' > Create a svg graphics for Guitar and Ukulele chord 
    #'   diagrams.
    #'
    #' > _Arguments:_
    #'
    #' > - _name_ - name of the chord to be displayed on top
    #'   - _cstring_ - text representation of the chord
    #'   - _args_  - dictionary of settings for the look of the chord where the possible options are
    #'        - _-circlecolor_ - color of the fingerings, default: maroon
    #'        - _-outfile_ - name of the outfile, default: ""
    #'        - _width_ - image width, default: 100
    #' 
    #' > Example:
    #'
    #' ```{.tcl}
    #' package require tsvg
    #' package require tcrd
    #' tcrd svgchords C 0003 -circlecolor grey70 -outfile ukulele-c.svg
    #' tcrd svgchords F 2020 -circlecolor grey70 -outfile ukulele-f.svg
    #' tcrd svgchords G 0232 -circlecolor grey70 -outfile ukulele-g.svg
    #' tcrd svgchords Am 2000 -circlecolor grey70 -outfile ukulele-am.svg
    #' ```
    #'
    #' <div style="margin-left: 40px">
    #' ![](ukulele-c.svg) ![](ukulele-f.svg) ![](ukulele-g.svg) ![](ukulele-am.svg)
    #' </div>
    #'
    proc svgchords {name cstring args} {
        array set arg [list -circlecolor maroon -width 100 -height 255]
        if {[llength $args] == 1} {
            set outfile [lindex $args 0]
        } elseif {[llength $args] > 1}  {
            array set arg $args
            if {[info exists arg(-outfile)]} {
                set outfile $arg(-outfile)
            } else {
                set outfile ""
            }
        } else {
            set outfile ""
        }
        tsvg set code ""
        tsvg set width $arg(-width)
        tsvg set height $arg(-height)
        set ystart 48
        tsvg text x [expr {($arg(-width)/2)}] y 20 style "font: bold 24px sans-serif;" text-anchor middle $name 
        tsvg line x1 5 y1 $ystart x2 [expr {$arg(-width)-5}] y2 $ystart stroke-width 5 stroke black
        set inc [expr {($arg(-width)-20)/([string length $cstring]-1)}]
        for { set x 0 } { $x < [string length $cstring] } { incr x } {
            tsvg line x1 [expr {10+($x*$inc)}] y1 $ystart x2 [expr {10+($x*$inc)}] y2 248 stroke-width 2 stroke black
        }
        if {[string length $cstring] > 4} {
            set r 9
        } else {
            set r 9
        } 
        set mx 5
        for { set x 0 } { $x < $mx } { incr x } {    
            tsvg line x1 10 y1 [expr {$ystart+40+($x*40)}] x2 [expr {$arg(-width)-10}] y2 [expr {$ystart+40+($x*40)}] stroke-width 2 stroke black
            for {set y 0} { $y < [string length $cstring] } { incr y } {
                if {[string range $cstring $y $y] == $x} {
                    if {$x > 0} {
                        tsvg circle cx [expr {10+1+($y*$inc)}] cy [expr {$ystart-20+($x*40)}] r $r stroke $arg(-circlecolor) fill $arg(-circlecolor)
                    }
                }
                if {$x == 0 && [string range $cstring $y $y] == "x"} {
                    tsvg text x [expr {10+1+($y*$inc)}] y 42 style "font: 20px sans-serif;" text-anchor middle X
                } elseif {$x == 0 && [string range $cstring $y $y] == "0"} {
                    tsvg text x [expr {10+1+($y*$inc)}] y 42 style "font: 20px sans-serif;" text-anchor middle O
                }
            }
        }
        if {$outfile ne ""} {
            tsvg write $outfile
        } else {
            return [tsvg inline false]
        }
    }
}

#' ## EXAMPLES
#' 
#' ```{.tcl}
#' package require tcrd
#' tcrd svgchords C  x32010 -outfile guitar-c.svg -width 150
#' tcrd svgchords Dm xx0231 -outfile guitar-dm.svg -width 150
#' tcrd svgchords Em 022000 -outfile guitar-em.svg -width 150
#' tcrd svgchords F  x03211 -outfile guitar-f.svg -width 150
#' tcrd svgchords G  320003 -outfile guitar-g.svg -width 150
#' tcrd svgchords Am x02210 -outfile guitar-am.svg -width 150
#' ```
#'
#' <div style="margin-left: 40px">
#' ![](guitar-c.svg) ![](guitar-dm.svg) ![](guitar-em.svg) ![](guitar-f.svg)
#' ![](guitar-g.svg) ![](guitar-am.svg)
#' </div>
#'
#' ```{.tcl}
#' puts [tcrd chordsheet {
#' [Dm]Are you going to [C]Scarborough [Dm]Fair? 
#' [F]Parsley, [Dm]sage, rose [F]mary [G]and [Dm]thyme 
#' Remember [F]me to one who [C]lives there 
#' [Dm]He once [C]was a true love of [Dm]mine
#' }]
#' ```
#'


#' ## SEE ALSO
#'
#' - [mndoc](https://github.com/mittelmark/mndoc) - converting Markdown output to HTML 
#' - [tmdoc](https://github.com/mittelmark/tmdoc) - literate programming with Tcl which can use embedded chords and lyrics to produce music chord sheets for booklets
#' - [tsvg](https://github.com/mittelmark/tsvg) - draw svg graphics using Tcl commands, required package for _tcrd_ package to produce these svg chord charts
#'
#' ## AUTHOR
#'
#' @ 2025 - Detlef  Groth,  University  of  Potsdam,  Germany  -
#'   dgroth(at)uni(minus)potsdam(dot)de
#' 
#' ## LICENSE
#' 
#' 
#' ```
#' BSD 3-Clause License
#' 
#' Copyright (c) 2020-2025, Detlef Groth, University of Potsdam, Germany
#' 
#' All rights reserved.
#' 
#' Redistribution and use in source and binary forms, with or without
#' modification, are permitted provided that the following conditions are met:
#' 
#' 1. Redistributions of source code must retain the above copyright notice, this
#'    list of conditions and the following disclaimer.
#' 
#' 2. Redistributions in binary form must reproduce the above copyright notice,
#'    this list of conditions and the following disclaimer in the documentation
#'    and/or other materials provided with the distribution.
#' 
#' 3. Neither the name of the copyright holder nor the names of its
#'    contributors may be used to endorse or promote products derived from
#'    this software without specific prior written permission.
#' 
#' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#' IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#' FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#' DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#' SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#' CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#' OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#' OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#' ```
