
" popc-floaterm layer

" SECTION: variables {{{1

let s:popc = popc#popc#GetPopc()
let s:lyr = {}
let s:ftm = []
let s:mapsData = [
    \ ['popcfloaterm#Show'  , ['CR', 'Space'], 'Show floaterm'],
    \ ['popcfloaterm#New'   , ['n', 'N']     , 'New floaterm, N for input command'],
    \ ['popcfloaterm#Kill'  , ['c', 'C']     , 'Close floaterm, C for close all'],
    \ ['popcfloaterm#Rename', ['r']          , 'Rename floaterm'],
    \ ]


" SECTION: functions {{{1

" FUNCTION: popcfloaterm#Init() {{{
function! popcfloaterm#Init()
    let s:lyr = s:popc.addLayer('Floaterm', {
                \ 'bindCom' : 0,
                \ 'fnPop' : function('popcfloaterm#Pop'),
                \ })
    for md in s:mapsData
        call s:lyr.addMaps(md[0], md[1], md[2])
    endfor
    unlet! s:mapsData
endfunction
" }}}

" FUNCTION: s:createBuffer() {{{
function! s:createBuffer()
    let l:text = []

    let s:ftm = []
    let l:max = 0
    let l:name = []
    let l:info = []
    for bnr in floaterm#buflist#gather()
        call add(s:ftm, bnr)

        let opts = getbufvar(bnr, 'floaterm_opts')
        call add(l:name, has_key(opts, 'name') ? opts['name'] : 'UnNamed')
        let l:wid = strwidth(l:name[-1])
        let l:max = (l:wid > l:max) ? l:wid : l:max
        call add(l:info, getbufinfo(bnr)[0]['name'])
    endfor
    let l:max += 2

    for k in range(len(s:ftm))
        let l:line = printf('  %s%s @ %s',
                    \ l:name[k],
                    \ repeat(' ', l:max - strwidth(l:name[k]) - 2),
                    \ l:info[k],
                    \ )
        call add(l:text, l:line)
    endfor

    call s:lyr.setBufs(v:t_list, l:text)
endfunction
" }}}

" FUNCTION: popcfloaterm#Pop(...) {{{
function! popcfloaterm#Pop(...)
    call s:createBuffer()
    call popc#ui#Create(s:lyr.name)
endfunction
" }}}

" FUNCTION: popcfloaterm#Show() {{{
function! popcfloaterm#Show(key, index)
    if empty(s:ftm)
        return
    endif

    call popc#ui#Destroy()
    call floaterm#terminal#open_existing(s:ftm[a:index])
    if a:key ==# 'Space'
        call popc#ui#Create(s:lyr.name)
    endif
endfunction
" }}}

" FUNCTION: popcfloaterm#New(key, index) {{{
function! popcfloaterm#New(key, index)
    let l:cmd = ' '
    if a:key ==# 'N'
        let cmd .= popc#ui#Input('Input command: ', '', 'file')
    endif

    call popc#ui#Destroy()
    execute 'FloatermNew' . cmd
endfunction
" }}}

" FUNCTION: popcfloaterm#Kill(key, index) {{{
function! popcfloaterm#Kill(key, index)
    if empty(s:ftm)
        return
    endif

    if a:key ==# 'c'
        call floaterm#terminal#kill(s:ftm[a:index])
        call remove(s:ftm, a:index)
    elseif a:key ==# 'C'
        for bnr in s:ftm
            call floaterm#terminal#kill(bnr)
        endfor
        let s:ftm = []
    endif
    call popcfloaterm#Pop()
endfunction
" }}}

" FUNCTION: popcfloaterm#Rename(key, index) {{{
function! popcfloaterm#Rename(key, index)
    if empty(s:ftm)
        return
    endif

    let name = popc#ui#Input('Input name: ')
    call floaterm#buffer#update_opts(s:ftm[a:index], {'name': name})
    call popcfloaterm#Pop()
endfunction
" }}}
