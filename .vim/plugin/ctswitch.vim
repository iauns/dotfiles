" ============================================================================
" File:        ctswitch.vim
"
" Description: Plugin to switch between C / CPP implementation files and their
"              corresponding test files.
"
" Maintainer:  James Hughes <>
"
" Last Change: July 29, 2012
"
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================

" This plugin is essentially Derek Wyatt's FSwitch plugin. Not much has changed.

"|buffer-variable|    b:variable  Local to the current buffer. 
"|window-variable|    w:variable  Local to the current window. 
"|global-variable|    g:variable  Global. 
"|local-variable|     l:variable  Local to a function. 
"|script-variable|    s:variable  Local to a |:source|'ed Vim script. 
"|function-argument|  a:argument  Function argument (only inside a function). 
"|vim-variable|       v:variable  Global, predefined by Vim. 

if exists("g:disable_ctswitch")
    finish
endif

if v:version < 700
  echoerr "CTSwitch requires Vim 7.0 or higher!"
  finish
endif

" Version
let s:ctswitch_version = '0.1.0'

" Get the path separator right
let s:os_slash = &ssl == 0 && (has("win16") || has("win32") || has("win64")) ? '\' : '/'

" Default locations - appended to buffer locations unless otherwise specified
let s:ctswitch_global_locs = '.' . s:os_slash

"
" s:SetVariables
"
" There are two variables that need to be set in the buffer in order for things
" to work correctly.  Because we're using an autocmd to set things up we need to
" be sure that the user hasn't already set them for us explicitly so we have
" this function just to check and make sure.  If the user's autocmd runs after
" ours then they will override the value anyway.
"
function! s:SetVariables(dst, locs)
    if !exists("b:ctswitchdst")
        let b:ctswitchdst = a:dst
    endif
    if !exists("b:ctswitchlocs")
        let b:ctswitchlocs = a:locs
    endif
endfunction

"
" s:CTSGetPrefixes
"
" Return a list of file prefixes.
"
function! s:CTSGetPrefixes()
    let prefixes = []
    if exists("b:ctswitchprefixes")
        let prefixes = split(b:ctswitchprefixes, ',')
    else
        let prefixes = ['']
    endif
    return prefixes
endfunction

"
" s:CTSGetLocations
"
" Return the list of possible locations
"
function! s:CTSGetLocations()
    let locations = []
    if exists("b:ctswitchlocs")
        let locations = split(b:ctswitchlocs, ',')
    endif
    if !exists("b:ctsdisablegloc") || b:ctsdisablegloc == 0
        let locations += split(s:ctswitch_global_locs, ',')
    endif

    return locations
endfunction

"
" s:CTSGetExtensions
"
" Return the list of destination extensions
"
function! s:CTSGetExtensions()
    return split(b:ctswitchdst, ',')
endfunction

"
" s:CTSGetMustMatch
"
" Return a boolean on whether or not the regex must match
"
function! s:CTSGetMustMatch()
    let mustmatch = 1
    if exists("b:ctsneednomatch") && b:ctsneednomatch != 0
        let mustmatch = 0
    endif

    return mustmatch
endfunction

"
" s:CTSGetFullPathToDirectory
"
" Given the filename, return the fully qualified directory portion
"
function! s:CTSGetFullPathToDirectory(filename)
    return expand(a:filename . ':p:h')
endfunction

"
" s:CTSGetFileExtension
"
" Given the filename, returns the extension
"
function! s:CTSGetFileExtension(filename)
    return expand(a:filename . ':e')
endfunction

"
" s:CTSGetFileNameWithoutExtension
"
" Given the filename, returns just the file name without the path or extension
"
function! s:CTSGetFileNameWithoutExtension(filename)
    return expand(a:filename . ':t:r')
endfunction

"
" s:CTSGetAlternateFilename
"
" Takes the path, name and extension of the file in the current buffer and
" applies the location to it.  If the location is a regular expression pattern
" then it will split that up and apply it accordingly.  If the location pattern
" is actually an explicit relative path or an implicit one (default) then it
" will simply apply that to the file directly.
"
function! s:CTSGetAlternateFilename(filepath, filename, newextension, location, filePrefix, negatePrefix, mustmatch)
    let parts = split(a:location, ':')
    let cmd = 'rel'
    let directive = parts[0]
    if len(parts) == 2
        let cmd = parts[0]
        let directive = parts[1]
    endif
    if cmd == 'reg' || cmd == 'ifrel' || cmd == 'ifabs'
        if strlen(directive) < 3
            throw 'Bad directive "' . a:location . '".'
        else
            let separator = strpart(directive, 0, 1)
            let dirparts = split(strpart(directive, 1), separator)
            if len(dirparts) < 2 || len(dirparts) > 3
                throw 'Bad directive "' . a:location . '".'
            else
                let part1 = dirparts[0]
                let part2 = dirparts[1]
                let flags = ''
                if len(dirparts) == 3
                    let flags = dirparts[2]
                endif
                if cmd == 'reg'
                    if a:mustmatch == 1 && match(a:filepath, part1) == -1
                        let path = ""
                    else
                        if a:negatePrefix == 0
                            let path = substitute(a:filepath, part1, part2, flags) . s:os_slash .
                                  \ a:filePrefix . a:filename . '.' . a:newextension
                        else
                            let path = substitute(a:filepath, part1, part2, flags) . s:os_slash .
                                  \ substitute(a:filename, '^' . a:filePrefix, '', '') . '.' . a:newextension
                        endif
                    endif
                elseif cmd == 'ifrel'
                    if match(a:filepath, part1) == -1
                        let path = ""
                    else
                        if a:negatePrefix == 0
                            let path = a:filepath . s:os_slash . part2 . 
                                       \ s:os_slash . a:filePrefix . a:filename . '.' . a:newextension
                        else
                            let path = a:filepath . s:os_slash . part2 . 
                                       \ s:os_slash . substitute(a:filename, '^' . a:filePrefix, '', '') . '.' . a:newextension
                        endif
                    endif
                elseif cmd == 'ifabs'
                    if match(a:filepath, part1) == -1
                        let path = ""
                    else
                        if a:negatePrefix == 0
                            let path = part2 . s:os_slash . a:filePrefix . a:filename . '.' . a:newextension
                        else
                            let path = part2 . s:os_slash . substitute(a:filename, '^' . a:filePrefix, '', '') . '.' . a:newextension
                        endif
                    endif
                endif
            endif
        endif
    elseif cmd == 'rel'
        if a:negatePrefix == 0
            let path = a:filepath . s:os_slash . directive . s:os_slash . a:filePrefix . a:filename . '.' . a:newextension
        else
            let path = a:filepath . s:os_slash . directive . s:os_slash . substitute(a:filename, '^' . a:filePrefix, '', '') . '.' . a:newextension
        endif
    elseif cmd == 'abs'
        if a:negatePrefix == 0
            let path = directive . s:os_slash . a:filePrefix . a:filename . '.' . a:newextension
        else
            let path = directive . s:os_slash . substitute(a:filename, '^' . a:filePrefix, '', '') . '.' . a:newextension
        endif
    endif

    return simplify(path)
endfunction

"
" s:FSReturnCompanionFilename
"
" This function will return a path that is the best candidate for the companion
" file to switch to.  If mustBeReadable == 1 when then the companion file will
" only be returned if it is readable on the filesystem, otherwise it will be
" returned so long as it is non-empty.
"
function! s:CTSReturnCompanionFilename(filename, mustBeReadable)
    let fullpath = s:CTSGetFullPathToDirectory(a:filename)
    let ext = s:CTSGetFileExtension(a:filename)
    let justfile = s:CTSGetFileNameWithoutExtension(a:filename)
    let extensions = s:CTSGetExtensions()
    let locations = s:CTSGetLocations()
    let mustmatch = s:CTSGetMustMatch()
    let prefixes = s:CTSGetPrefixes()
    let newpath = ''
    for currentExt in extensions
        for loc in locations
            for pfx in prefixes
                let newpath = s:CTSGetAlternateFilename(fullpath, justfile, currentExt, loc, pfx, 0, mustmatch)
                if a:mustBeReadable == 0 && newpath != ''
                    return newpath
                elseif a:mustBeReadable == 1
                    let newpath = glob(newpath)
                    if filereadable(newpath)
                        return newpath
                    else
                        let newpath = glob(s:CTSGetAlternateFilename(fullpath, justfile, currentExt, loc, pfx, 1, mustmatch))
                        if filereadable(newpath)
                            return newpath
                        endif
                    endif
                endif
            endfor
        endfor
    endfor

    return newpath
endfunction

"
" CTSReturnReadableCompanionFilename
"
" This function will return a path that is the best candidate for the companion
" file to switch to, so long as that file actually exists on the filesystem and
" is readable.
" 
function! CTSReturnReadableCompanionFilename(filename)
    return s:CTSReturnCompanionFilename(a:filename, 1)
endfunction

"
" CTSReturnCompanionFilenameString
"
" This function will return a path that is the best candidate for the companion
" file to switch to.  The file does not need to actually exist on the
" filesystem in order to qualify as a proper companion.
"
function! CTSReturnCompanionFilenameString(filename)
    return s:CTSReturnCompanionFilename(a:filename, 0)
endfunction

"
" CTSwitch
"
" This is the only externally accessible function and is what we use to switch
" to the alternate file.
"
function! CTSwitch(filename, precmd)
    if !exists("b:ctswitchdst") || strlen(b:ctswitchdst) == 0
        throw 'b:ctswitchdst not set - read :help ctswitch'
    endif
    if (!exists("b:ctswitchlocs")   || strlen(b:ctswitchlocs) == 0) &&
     \ (!exists("b:ctsdisablegloc") || b:ctsdisablegloc == 0)
        throw "There are no locations defined (see :h ctswitchlocs and :h ctsdisablegloc)"
    endif
    let newpath = CTSReturnReadableCompanionFilename(a:filename)
    let openfile = 1
    if !filereadable(newpath)
        if exists("b:ctsnonewfiles") || exists("g:ctsnonewfiles")
            let openfile = 0
        else
            let newpath = CTSReturnCompanionFilenameString(a:filename)
        endif
    endif
    if openfile == 1
        if newpath != ''
            if strlen(a:precmd) != 0
                execute a:precmd
            endif
            execute 'edit ' . fnameescape(newpath)
        else
            echoerr "Alternate has evaluated to nothing.  See :h ctswitch-empty for more info."
        endif
    else
        echoerr "No alternate file found.  'ctsnonewfiles' is set which denies creation."
    endif
endfunction

"
" The autocmds we set up to set up the buffer variables for us.
"
augroup ctswitch_au_group
    au!
    au BufEnter *.h call s:SetVariables('cpp,c', 'reg:/include/src/,reg:/include.*/src/,ifrel:|/include/|../src|')
    au BufEnter *.c,*.cpp call s:SetVariables('h', 'reg:/src/include/,reg:|src|include/**|,ifrel:|/src/|../include|')
augroup END

"
" The mappings used to do the good work
"
com! CTSHere       :call CTSwitch('%', '')
com! CTSRight      :call CTSwitch('%', 'wincmd l')
com! CTSSplitRight :call CTSwitch('%', 'vsplit | wincmd l')
com! CTSLeft       :call CTSwitch('%', 'wincmd h')
com! CTSSplitLeft  :call CTSwitch('%', 'vsplit | wincmd h')
com! CTSAbove      :call CTSwitch('%', 'wincmd k')
com! CTSSplitAbove :call CTSwitch('%', 'split | wincmd k')
com! CTSBelow      :call CTSwitch('%', 'wincmd j')
com! CTSSplitBelow :call CTSwitch('%', 'split | wincmd j')

