" PopcFloaterm: Popc pluging for floaterm.
" Maintainer: yehuohan, <yehuohan@qq.com>, <yehuohan@gmail.com>
" Version: 0.1
"

" SETCION: vim-script {{{1
if exists("g:popc_floaterm_loaded")
    finish
endif

let g:popc_floaterm_loaded = 1

if !exists("g:popc_loaded")
    echohl WarningMsg
    echomsg "[PopcFloaterm] Popc is required!"
    echohl None
    finish
endif

call popcfloaterm#Init()
