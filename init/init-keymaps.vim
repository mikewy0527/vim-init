"======================================================================
"
" init-keymaps.vim - 按键设置，按你喜欢更改
"
"   - 快速移动
"   - 标签切换
"   - 窗口切换
"   - 终端支持
"   - 编译运行
"   - 符号搜索
"
" Created by skywind on 2018/05/30
" Last Modified: 2018/05/30 17:59:31
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :


"----------------------------------------------------------------------
" INSERT/COMMAND 模式下 Bash 式键映射
" 函数定义参考 https://github.com/houtsnip/vim-emacscommandline
"----------------------------------------------------------------------

" vim-emacscmdline function -----------------------------------------------{{{1
if !exists('g:CmdlineMaxUndoHistory')
    let g:CmdlineMaxUndoHistory = 100
endif

if !exists('g:CmdlineWordCharCharacterClass')
    " Latin-1, Latin Extended-A, Extended-B, Greek and Coptic, and Cyrillic scripts:
    "let g:CmdlineWordCharCharacterClass = 'a-zA-Z0-9_À-ÖØ-öø-ÿĀ-ǿȀ-ɏͰ-ͳͶͷΆΈΉΊΌΎ-ΡΣ-ώϚ-ϯϷϸϺϻЀ-ҁ'
    " Latin-1 (the most common European letters):
    let g:CmdlineWordCharCharacterClass = 'a-zA-Z0-9_À-ÖØ-öø-ÿ'
    " Basic Latin (unaccented) word characters:
    "let g:CmdlineWordCharCharacterClass = '\w'
endif

function! <SID>ForwardWord()
    let l:loc = strpart(getcmdline(), 0, getcmdpos() - 1)
    let l:roc = strpart(getcmdline(), getcmdpos() - 1)
    if l:roc =~ '\v^\s*[' . g:CmdlineWordCharCharacterClass . ']'
        let l:rem = matchstr(l:roc, '\v^\s*[' . g:CmdlineWordCharCharacterClass . ']+')
    elseif l:roc =~ '\v^\s*[^[:alnum:]_[:blank:]]'
        let l:rem = matchstr(l:roc, '\v^\s*[^[:alnum:]_[:blank:]]+')
    else
        call setcmdpos(strlen(getcmdline()) + 1)
        return getcmdline()
    endif
    call setcmdpos(strlen(l:loc) + strlen(l:rem) + 1)
    return getcmdline()
endfunction

function! <SID>BackwardWord()
    let l:loc = strpart(getcmdline(), 0, getcmdpos() - 1)
    let l:roc = strpart(getcmdline(), getcmdpos() - 1)
    if l:loc =~ '\v[' . g:CmdlineWordCharCharacterClass . ']\s*$'
        let l:rem = matchstr(l:loc, '\v[' . g:CmdlineWordCharCharacterClass . ']+\s*$')
    elseif l:loc =~ '\v[^[:alnum:]_[:blank:]]\s*$'
        let l:rem = matchstr(l:loc, '\v[^[:alnum:]_[:blank:]]+\s*$')
    else
        call setcmdpos(1)
        return getcmdline()
    endif
    let @c = l:rem
    call setcmdpos(strlen(l:loc) - strlen(l:rem) + 1)
    return getcmdline()
endfunction

function! <SID>KillLine()
    call <SID>SaveUndoHistory(getcmdline(), getcmdpos())
    let l:cmd = getcmdline()
    let l:rem = strpart(l:cmd, getcmdpos() - 1)
    if '' != l:rem
        let @c = l:rem
    endif
    let l:ret = strpart(l:cmd, 0, getcmdpos() - 1)
    call <SID>SaveUndoHistory(l:ret, getcmdpos())
    return l:ret
endfunction

function! <SID>BackwardKillLine()
    call <SID>SaveUndoHistory(getcmdline(), getcmdpos())
    let l:cmd = getcmdline()
    let l:rem = strpart(l:cmd, 0, getcmdpos() - 1)
    if '' != l:rem
        let @c = l:rem
    endif
    let l:ret = strpart(l:cmd, getcmdpos() - 1)
    call <SID>SaveUndoHistory(l:ret, 1)
    call setcmdpos(1)
    return l:ret
endfunction

function! <SID>KillWord()
    call <SID>SaveUndoHistory(getcmdline(), getcmdpos())
    let l:loc = strpart(getcmdline(), 0, getcmdpos() - 1)
    let l:roc = strpart(getcmdline(), getcmdpos() - 1)
    if l:roc =~ '\v^\s*[' . g:CmdlineWordCharCharacterClass . ']'
        let l:rem = matchstr(l:roc, '\v^\s*[' . g:CmdlineWordCharCharacterClass . ']+')
    elseif l:roc =~ '\v^\s*[^[:alnum:]_[:blank:]]'
        let l:rem = matchstr(l:roc, '\v^\s*[^[:alnum:]_[:blank:]]+')
    elseif l:roc =~ '\v^\s+$'
        let @c = l:roc
        return l:loc
    else
        return getcmdline()
    endif
    let @c = l:rem
    let l:ret = l:loc . strpart(l:roc, strlen(l:rem))
    call <SID>SaveUndoHistory(l:ret, getcmdpos())
    return l:ret
endfunction

function! <SID>BackwardKillWord()
    " Do same as in-built Ctrl-W, except assign deleted text to @c
    call <SID>SaveUndoHistory(getcmdline(), getcmdpos())
    let l:loc = strpart(getcmdline(), 0, getcmdpos() - 1)
    let l:roc = strpart(getcmdline(), getcmdpos() - 1)
    if l:loc =~ '\v[' . g:CmdlineWordCharCharacterClass . ']\s*$'
        let l:rem = matchstr(l:loc, '\v[' . g:CmdlineWordCharCharacterClass . ']+\s*$')
    elseif l:loc =~ '\v[^[:alnum:]_[:blank:]]\s*$'
        let l:rem = matchstr(l:loc, '\v[^[:alnum:]_[:blank:]]+\s*$')
    elseif l:loc =~ '\v^\s+$'
        let @c = l:loc
        call setcmdpos(1)
        return l:roc
    else
        return getcmdline()
    endif
    let @c = l:rem
    let l:pos = getcmdpos() - strlen(l:rem)
    let l:ret = strpart(l:loc, 0, strlen(l:loc) - strlen(l:rem)) . l:roc
    call <SID>SaveUndoHistory(l:ret, l:pos)
    call setcmdpos(l:pos)
    return l:ret
endfunction

let s:oldcmdline = [ ]
function! <SID>SaveUndoHistory(cmdline, cmdpos)
    if len(s:oldcmdline) == 0 || a:cmdline != s:oldcmdline[0][0]
        call insert(s:oldcmdline, [ a:cmdline, a:cmdpos ], 0)
    else
        let s:oldcmdline[0][1] = a:cmdpos
    endif
    if len(s:oldcmdline) > g:CmdlineMaxUndoHistory
        call remove(s:oldcmdline, g:CmdlineMaxUndoHistory)
    endif
endfunction

function! <SID>Yank()
    let l:cmd = getcmdline()
    call setcmdpos(getcmdpos() + strlen(@c))
    return strpart(l:cmd, 0, getcmdpos() - 1) . @c . strpart(l:cmd, getcmdpos() - 1)
endfunction

function! <SID>Undo()
    if len(s:oldcmdline) == 0
        return getcmdline()
    endif
    if getcmdline() ==# s:oldcmdline[0][0]
        call remove(s:oldcmdline, 0)
        if len(s:oldcmdline) == 0
            return getcmdline()
        endif
    endif
    let l:ret = s:oldcmdline[0][0]
    call setcmdpos(s:oldcmdline[0][1])
    call remove(s:oldcmdline, 0)
    return l:ret
endfunction
".}}}1

noremap! <C-a> <Home>
inoremap <C-e> <End>
noremap! <C-b> <Left>
noremap! <C-f> <Right>
inoremap <C-p> <Up>
inoremap <C-n> <Down>

" ALT+j/k 逻辑跳转下一行/上一行（按 wrap 逻辑换行进行跳转）
nnoremap <M-j> gj
nnoremap <M-k> gk
inoremap <M-j> <C-\><C-o>gj
inoremap <M-k> <C-\><C-o>gk

inoremap <M-b> <S-Left>
inoremap <M-f> <S-Right>
cnoremap <M-b> <C-\>e <SID>BackwardWord()<CR>
cnoremap <M-f> <C-\>e <SID>ForwardWord()<CR>

" delete form cursor to line-end
" In COMMAND mode, use custom function to make Yank and Undo work correctly
inoremap <C-k> <C-\><C-o>D
cnoremap <C-k> <C-\>e <SID>KillLine()<CR>
cnoremap <C-u> <C-\>e <SID>BackwardKillLine()<CR>

" delete-forward word
inoremap <M-d> <C-\><C-o>dw
cnoremap <M-d> <C-\>e <SID>KillWord()<CR>
cnoremap <C-w> <C-\>e <SID>BackwardKillWord()<CR>

cnoremap <C-y> <C-\>e <SID>Yank()<CR>
cnoremap <C-_> <C-\>e <SID>Undo()<CR>


" tabline switch tab keymap -----------------------------------------------{{{1
"----------------------------------------------------------------------
" <leader>+数字键 切换tab
"----------------------------------------------------------------------
noremap <silent><leader>1 1gt<cr>
noremap <silent><leader>2 2gt<cr>
noremap <silent><leader>3 3gt<cr>
noremap <silent><leader>4 4gt<cr>
noremap <silent><leader>5 5gt<cr>
noremap <silent><leader>6 6gt<cr>
noremap <silent><leader>7 7gt<cr>
noremap <silent><leader>8 8gt<cr>
noremap <silent><leader>9 9gt<cr>
noremap <silent><leader>0 10gt<cr>


"----------------------------------------------------------------------
" ALT+N 切换 tab
"----------------------------------------------------------------------
if has("gui_running")
    noremap <silent><M-1> :tabn 1<CR>
    noremap <silent><M-2> :tabn 2<CR>
    noremap <silent><M-3> :tabn 3<CR>
    noremap <silent><M-4> :tabn 4<CR>
    noremap <silent><M-5> :tabn 5<CR>
    noremap <silent><M-6> :tabn 6<CR>
    noremap <silent><M-7> :tabn 7<CR>
    noremap <silent><M-8> :tabn 8<CR>
    noremap <silent><M-9> :tabn 9<CR>
    noremap <silent><M-0> :tabn 10<CR>
    inoremap <silent><M-1> <ESC>:tabn 1<CR>
    inoremap <silent><M-2> <ESC>:tabn 2<CR>
    inoremap <silent><M-3> <ESC>:tabn 3<CR>
    inoremap <silent><M-4> <ESC>:tabn 4<CR>
    inoremap <silent><M-5> <ESC>:tabn 5<CR>
    inoremap <silent><M-6> <ESC>:tabn 6<CR>
    inoremap <silent><M-7> <ESC>:tabn 7<CR>
    inoremap <silent><M-8> <ESC>:tabn 8<CR>
    inoremap <silent><M-9> <ESC>:tabn 9<CR>
    inoremap <silent><M-0> <ESC>:tabn 10<CR>
endif


" MacVim 允许 CMD+数字键快速切换标签
if has("gui_macvim")
    set macmeta
    noremap <silent><D-1> :tabn 1<CR>
    noremap <silent><D-2> :tabn 2<CR>
    noremap <silent><D-3> :tabn 3<CR>
    noremap <silent><D-4> :tabn 4<CR>
    noremap <silent><D-5> :tabn 5<CR>
    noremap <silent><D-6> :tabn 6<CR>
    noremap <silent><D-7> :tabn 7<CR>
    noremap <silent><D-8> :tabn 8<CR>
    noremap <silent><D-9> :tabn 9<CR>
    noremap <silent><D-0> :tabn 10<CR>
    inoremap <silent><D-1> <ESC>:tabn 1<CR>
    inoremap <silent><D-2> <ESC>:tabn 2<CR>
    inoremap <silent><D-3> <ESC>:tabn 3<CR>
    inoremap <silent><D-4> <ESC>:tabn 4<CR>
    inoremap <silent><D-5> <ESC>:tabn 5<CR>
    inoremap <silent><D-6> <ESC>:tabn 6<CR>
    inoremap <silent><D-7> <ESC>:tabn 7<CR>
    inoremap <silent><D-8> <ESC>:tabn 8<CR>
    inoremap <silent><D-9> <ESC>:tabn 9<CR>
    inoremap <silent><D-0> <ESC>:tabn 10<CR>
endif
".}}}1

"----------------------------------------------------------------------
" TAB：创建，关闭，上一个，下一个，左移，右移
" 其实还可以用原生的 CTRL+PageUp, CTRL+PageDown 来切换标签
"----------------------------------------------------------------------
" tabline operation keymap ------------------------------------------------{{{1

" Keep a list of the most recent two tabs.
let g:tablist = [1, 1]

augroup TabCloseFocusPrevgroup
    autocmd!

    autocmd TabLeave * let g:tablist[0] = g:tablist[1]
    autocmd TabLeave * let g:tablist[1] = tabpagenr()
    " When a tab is closed, return to the most recent tab.
    " The way vim updates tabs, in reality, this means we must return
    " to the second most recent tab.
    autocmd TabClosed * exe "normal " . g:tablist[0] . "gt"
augroup end

noremap <silent> <leader>tc :tabnew<CR>
noremap <silent> <leader>tq :tabclose<CR>
noremap <silent> <leader>tn :tabnext<CR>
noremap <silent> <leader>tp :tabprev<CR>
noremap <silent> <leader>to :tabonly<CR>


" 左移 tab
function! Tab_MoveLeft()
    let l:tabnr = tabpagenr() - 2
    if l:tabnr >= 0
        exec 'tabmove '.l:tabnr
    endif
endfunc

" 右移 tab
function! Tab_MoveRight()
    let l:tabnr = tabpagenr() + 1
    if l:tabnr <= tabpagenr('$')
        exec 'tabmove '.l:tabnr
    endif
endfunc

noremap <silent><leader>tl :call Tab_MoveLeft()<CR>
noremap <silent><leader>tr :call Tab_MoveRight()<CR>

if has("gui_running")
    noremap <silent><M-Left> :call Tab_MoveLeft()<CR>
    noremap <silent><M-Right> :call Tab_MoveRight()<CR>
endif
".}}}1

"----------------------------------------------------------------------
" 窗口切换：ALT+SHIFT+hjkl
" 传统的 CTRL+hjkl 移动窗口不适用于 vim 8.1 的终端模式，CTRL+hjkl 在
" bash/zsh 及带文本界面的程序中都是重要键位需要保留，不能 tnoremap 的
"----------------------------------------------------------------------
" switch window keymap ----------------------------------------------------{{{1
noremap <M-H> <C-w>h
noremap <M-L> <C-w>l
noremap <M-J> <C-w>j
noremap <M-K> <C-w>k
inoremap <M-H> <Esc><C-w>h
inoremap <M-L> <Esc><C-w>l
inoremap <M-J> <Esc><C-w>j
inoremap <M-K> <Esc><C-w>k

if has('terminal') && exists(':terminal') == 2 && has('patch-8.1.1')
    " workaround for binding keys with meta key
    if has('vim9script')
        def FixMetaReadline()
            for key in (range(char2nr('a'), char2nr('z'))
                      + range(char2nr('A'), char2nr('Z')))->mapnew((_, v) => nr2char(v))
                execute 'tnoremap <M-' .. key .. '> <Esc>' .. key
            endfor
        enddef
    else
        function FixMetaReadline() abort
            for key in map(range(char2nr('a'), char2nr('z')) + range(char2nr('A'), char2nr('Z')), 'nr2char(v:val)')
                exe 'tno <m-' .. key .. '> <esc>' .. key
            endfor
        endfunc
    endif
    call FixMetaReadline()

    " vim 8.1 支持 termwinkey ，不需要把 terminal 切换成 normal 模式
    " 设置 termwinkey 为 CTRL 加减号（GVIM），有些终端下是 CTRL+?
    " 后面四个键位是搭配 termwinkey 的，如果 termwinkey 更改，也要改
    set termwinkey=<C-_>
    tnoremap <M-H> <C-_>h
    tnoremap <M-L> <C-_>l
    tnoremap <M-J> <C-_>j
    tnoremap <M-K> <C-_>k
    tnoremap <M-q> <C-\><C-n>

    tnoremap <M-1> <C-_>1gt
    tnoremap <M-2> <C-_>2gt
    tnoremap <M-3> <C-_>3gt
    tnoremap <M-4> <C-_>4gt
    tnoremap <M-5> <C-_>5gt
    tnoremap <M-6> <C-_>6gt
    tnoremap <M-7> <C-_>7gt
    tnoremap <M-8> <C-_>8gt
    tnoremap <M-9> <C-_>9gt
    tnoremap <M-0> <C-_>10gt
elseif has('nvim')
    " neovim 没有 termwinkey 支持，必须把 terminal 切换回 normal 模式
    tnoremap <M-H> <C-\><C-n><C-w>h
    tnoremap <M-L> <C-\><C-n><C-w>l
    tnoremap <M-J> <C-\><C-n><C-w>j
    tnoremap <M-K> <C-\><C-n><C-w>k
    tnoremap <M-q> <C-\><C-n>

    tnoremap <M-1> <C-\><C-n>1gt
    tnoremap <M-2> <C-\><C-n>2gt
    tnoremap <M-3> <C-\><C-n>3gt
    tnoremap <M-4> <C-\><C-n>4gt
    tnoremap <M-5> <C-\><C-n>5gt
    tnoremap <M-6> <C-\><C-n>6gt
    tnoremap <M-7> <C-\><C-n>7gt
    tnoremap <M-8> <C-\><C-n>8gt
    tnoremap <M-9> <C-\><C-n>9gt
    tnoremap <M-0> <C-\><C-n>10gt
endif
".}}}1

"----------------------------------------------------------------------
" 打开/关闭 quickfix window
"----------------------------------------------------------------------
" quickfix toggle function ------------------------------------------------{{{1
function! QuickfixToggle(size, ...)
    echo "call QuickfixToggle"
    let l:mode = (a:0 == 0)? 2 : (a:1)
    function! s:WindowCheck(mode)
        if &buftype == 'quickfix'
            let s:quickfix_open = 1
            return
        endif
        if a:mode == 0
            let w:quickfix_save = winsaveview()
        else
            if exists('w:quickfix_save')
                call winrestview(w:quickfix_save)
                unlet w:quickfix_save
            endif
        endif
    endfunc

    let s:quickfix_open = 0
    let l:winnr = winnr()
    keepalt noautocmd windo call s:WindowCheck(0)
    keepalt noautocmd silent! exec ''.l:winnr.'wincmd w'
    if l:mode == 0
        if s:quickfix_open != 0
            silent! cclose
        endif
    elseif l:mode == 1
        if s:quickfix_open == 0
            keepalt exec 'botright copen '. ((a:size > 0)? a:size : ' ')
            keepalt wincmd k
        endif
    elseif l:mode == 2
        if s:quickfix_open == 0
            keepalt exec 'botright copen '. ((a:size > 0)? a:size : ' ')
            keepalt wincmd k
        else
            silent! cclose
        endif
    endif
    keepalt noautocmd windo call s:WindowCheck(1)
    keepalt noautocmd silent! exec ''.l:winnr.'wincmd w'
endfunction
".}}}1

nnoremap <leader>q :call QuickfixToggle(6)<CR>

" vim: set fdl=0 fdm=marker:
