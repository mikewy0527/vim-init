"======================================================================
"
" init-config.vim - 正常模式下的配置，在 init-basic.vim 后调用
"
" Created by skywind on 2018/05/30
" Last Modified: 2018/05/30 19:20:46
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :


"----------------------------------------------------------------------
" 功能键超时（毫秒）
"----------------------------------------------------------------------
if $TMUX != ''
    set ttimeoutlen=30
elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
    set ttimeoutlen=80
endif


"----------------------------------------------------------------------
" 终端下允许 ALT，详见：http://www.skywind.me/blog/archives/2021
" 记得设置 ttimeout （见 init-basic.vim） 和 ttimeoutlen （上面）
"----------------------------------------------------------------------
if !has('nvim') && !has('gui_running')
    function! Terminal_MetaMode(mode)
       function! s:metacode(mode, key)
            if a:mode == 0
                exec "set <M-".a:key.">=\e".a:key
            else
                exec "set <M-".a:key.">=\e]{0}".a:key."~"
            endif
        endfunc
        for i in range(10)
            call s:metacode(a:mode, nr2char(char2nr('0') + i))
        endfor
        for i in range(26)
            call s:metacode(a:mode, nr2char(char2nr('a') + i))
            call s:metacode(a:mode, nr2char(char2nr('A') + i))
        endfor
        if a:mode != 0
            for c in [',', '.', '/', ';', '[', ']', '{', '}']
                call s:metacode(a:mode, c)
            endfor
            for c in ['?', ':', '-', '_']
                call s:metacode(a:mode, c)
            endfor
        else
            for c in [',', '.', '/', ';', '{', '}']
                call s:metacode(a:mode, c)
            endfor
            for c in ['?', ':', '-', '_']
                call s:metacode(a:mode, c)
            endfor
        endif
    endfunc

    call Terminal_MetaMode(0)
endif


"----------------------------------------------------------------------
" 功能键终端码矫正
"----------------------------------------------------------------------
if !has('nvim') && !has('gui_running')
    function! s:key_escape(name, code)
        exec "set ".a:name."=\e".a:code
    endfunc

    call s:key_escape('<F1>', 'OP')
    call s:key_escape('<F2>', 'OQ')
    call s:key_escape('<F3>', 'OR')
    call s:key_escape('<F4>', 'OS')
    call s:key_escape('<S-F1>', '[1;2P')
    call s:key_escape('<S-F2>', '[1;2Q')
    call s:key_escape('<S-F3>', '[1;2R')
    call s:key_escape('<S-F4>', '[1;2S')
    call s:key_escape('<S-F5>', '[15;2~')
    call s:key_escape('<S-F6>', '[17;2~')
    call s:key_escape('<S-F7>', '[18;2~')
    call s:key_escape('<S-F8>', '[19;2~')
    call s:key_escape('<S-F9>', '[20;2~')
    call s:key_escape('<S-F10>', '[21;2~')
    call s:key_escape('<S-F11>', '[23;2~')
    call s:key_escape('<S-F12>', '[24;2~')
endif


"----------------------------------------------------------------------
" 防止tmux下vim的背景色显示异常
" Refer: http://sunaku.github.io/vim-256color-bce.html
"----------------------------------------------------------------------
if &term =~ '256color' && $TMUX != ''
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif


"----------------------------------------------------------------------
" 备份设置
"----------------------------------------------------------------------

" 允许备份
set backup

" 保存时备份
set writebackup

" 备份文件地址，统一管理
set backupdir=~/.vim/.bak.d//

" 备份文件扩展名
" set backupext=.bak

" 禁用交换文件
" set noswapfile
set directory=~/.vim/.swp.d//

" 禁用 undo文件
" set noundofile
set undodir=~/.vim/.undo.d//

" 创建目录，并且忽略可能出现的警告
silent! call mkdir(expand('~/.vim/.bak.d'), "p", 0755)
silent! call mkdir(expand('~/.vim/.swp.d'), "p", 0755)
silent! call mkdir(expand('~/.vim/.undo.d'), "p", 0755)


"----------------------------------------------------------------------
" 配置微调
"----------------------------------------------------------------------

" replace plugin 'chrisbra/vim-diff-enhanced'
set diffopt+=internal,algorithm:patience

" 修正 ScureCRT/XShell 以及某些终端乱码问题，主要原因是不支持一些
" 终端控制命令，比如 cursor shaping 这类更改光标形状的 xterm 终端命令
" 会令一些支持 xterm 不完全的终端解析错误，显示为错误的字符，比如 q 字符
" 如果你确认你的终端支持，不会在一些不兼容的终端上运行该配置，可以注释
" if has('nvim')
"     set guicursor=
" elseif (!has('gui_running')) && has('terminal') && has('patch-8.0.1200')
"     let g:termcap_guicursor = &guicursor
"     let g:termcap_t_RS = &t_RS
"     let g:termcap_t_SH = &t_SH
"     set guicursor=
"     set t_RS=
"     set t_SH=
" endif

" 打开文件时恢复上一次光标所在位置
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \     exe "normal! g`\"" |
    \ endif

" 定义一个 DiffOrig 命令用于查看文件改动
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif


"----------------------------------------------------------------------
" 文件类型微调
"----------------------------------------------------------------------
augroup InitFileTypesGroup
    " 清除同组的历史 autocommand
    au!

    " C/C++ 文件使用 // 作为注释
    au FileType c,cpp setlocal commentstring=//\ %s

    " markdown 允许自动换行
    au FileType markdown setlocal wrap

    " lisp 进行微调
    au FileType lisp setlocal ts=8 sts=2 sw=2 et

    " scala 微调
    au FileType scala setlocal sts=4 sw=4 noet

    " haskell 进行微调
    au FileType haskell setlocal et

    " quickfix 隐藏行号
    au FileType qf setlocal nonumber

    " 强制对某些扩展名的 filetype 进行纠正
    au BufNewFile,BufRead *.as setlocal filetype=actionscript
    au BufNewFile,BufRead *.pro setlocal filetype=prolog
    au BufNewFile,BufRead *.es setlocal filetype=erlang
    au BufNewFile,BufRead *.asc setlocal filetype=asciidoc
    au BufNewFile,BufRead *.vl setlocal filetype=verilog
    au BufNewFile,BufRead *.sublime-* setlocal filetype=json
augroup END

let g:terminal_ansi_colors = [
                \ "#232627", "#ba362a", "#19ca8c", "#e6ab45",
                \ "#1d99f3", "#9b59b6", "#1abc9c", "#e6e6e6",
                \ "#7f8c8d", "#f74782", "#10be13", "#ec6e00",
                \ "#3daee9", "#ae81ff", "#85dc85", "#e2637f"
                \]
