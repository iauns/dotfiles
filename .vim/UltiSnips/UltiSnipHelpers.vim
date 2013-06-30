
function! g:Ulti_InsertNameSpace(beginOrEnd)
    let dir = expand('%:p:h')
    let ext = expand('%:e')
    let rootDir = expand('pwd')
    if ext == 'cpp'
        let dir = FSReturnCompanionFilenameString('%')
        let dir = fnamemodify(dir, ':h')
    endif
    let idx = stridx(dir, rootDir.'/')
    let nsstring = ''
    if idx != -1
        let dir = strpart(dir, idx + strlen(rootDir) + 1)
        let nsnames = split(dir, '/')
        let nsdecl = join(nsnames, ' { namespace ')
        let nsdecl = 'namespace '.nsdecl.' {'
        if a:beginOrEnd == 0
            let nsstring = nsdecl
        else
            for i in nsnames
                let nsstring = nsstring.'} '
            endfor
            let nsstring =  nsstring . '// end of namespace '.join(nsnames, '::')
        endif
        let nsstring = nsstring
    endif

    return nsstring
endfunction

function! g:Ulti_InsertNameSpaceBegin()
    return g:Ulti_InsertNameSpace(0)
endfunction

function! g:Ulti_InsertNameSpaceEnd()
    return g:Ulti_InsertNameSpace(1)
endfunction

function! g:Ulti_GetNSFName(snipend)
    let dirAndFile = expand('%:p')
    let rootDir = expand('pwd')
    let idx = stridx(dirAndFile, rootDir)
    if idx != -1
        let fname = strpart(dirAndFile, idx + strlen(rootDir) + 1)
    else
        let fname = expand('%:t')
    endif
    if a:snipend == 1
        let fname = expand(fname.':r')
    endif

    return fname
endfunction

function! g:Ulti_GetNSFNameDefine()
    let dir = expand('%:p:h')
    let ext = toupper(expand('%:e'))
    let rootDir = expand('pwd')
    let idx = stridx(dir, rootDir)
    if idx != -1
        let subdir = strpart(dir, idx + strlen(rootDir) + 1)
        let define = substitute(subdir, '/', '_', 'g')
        let define = define ."_".expand('%:t:r')."_" . ext
        let define = toupper(define)
        let define = substitute(define, '^_\+', '', '')
        return define
    else
        return toupper(expand('%:t:r'))."_" . ext
    endif
endfunction

function! g:Ulti_GetHeaderForCurrentSourceFile()
    let header=FSReturnCompanionFilenameString('%')
    let header=substitute(header, '^'.expand('%:p:h').'/', '', '')
    let rootDir = expand('pwd')
    "if stridx(header, '/'.rootDir.'/') == -1
    "    let header = substitute(header, '^.*/'.rootDir.'/', '', '')
    "else
    "    let header = substitute(header, '^.*/'.rootDir.'/', '', '')
    "endif
    return header
endfunction

function! g:Ulti_GetNamespaceFilename(...)
    return g:Ulti_GetNSFName(0)
endfunction

function! g:Ulti_GetNamespaceFilenameDefine(...)
    return g:Ulti_GetNSFNameDefine()
endfunction

function! g:Ulti_GetHeaderForCurrentSourceFile(...)
    let header=FSReturnCompanionFilenameString('%')
    let header=substitute(header, '^'.expand('%:p:h').'/', '', '')
    return header
endfunction

function! g:Ulti_InsertNamespaceEnd(...)
    return g:Ulti_InsertNameSpaceEnd()
endfunction

function! g:Ulti_InsertNamespaceBegin(...)
    return g:Ulti_InsertNameSpaceBegin()
endfunction

function! g:Ulti_ReturnSkeletonsFromPrototypes(...)
    return protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({ 'includeNS' : 0})
endfunction

function! g:Ulti_InsertVariableAtTheEnd(type, varname)
endfunction


