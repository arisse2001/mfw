#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Priority: 300
# Description: Patch Appldr

# Option --patch-appldr-fself: Patch Appldr to allow Fself (set debug true)

# Type --patch-appldr: boolean

namespace eval ::patch_appldr {

    array set ::patch_appldr::options {
        --patch-appldr-fself true
    }

    proc main { } {
        set self "appldr"

        ::modify_coreos_file $self ::patch_appldr::patch_self
    }

    proc patch_self {self} {
        if {!$::patch_appldr::options(--patch-appldr-fself)} {
            log "WARNING: Enabled task has no enabled option" 1
        } else {
            ::modify_self_file $self ::patch_appldr::patch_elf
        }
    }

    proc patch_elf {elf} {
        if {$::patch_appldr::options(--patch-appldr-fself)} {
            log "Patching Appldr to allow Fself"

            set search  "\x40\x80\x0e\x0c\x20\x00\x57\x83\x32\x00\x04\x80\x32\x80\x80"
            set replace "\x40\x80\x0e\x0c\x20\x00\x57\x83\x32\x11\x73\x00\x32\x80\x80"

            catch_die {::patch_elf $elf $search 7 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
}