"======================================================================
"
" init-plugins.vim -
"
" Created by skywind on 2018/05/31
" Last Modified: 2018/06/10 23:11
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :


" 基础函数 ----------------------------------------------------------------{{{1
" 计算当前 vim-init 的子路径
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! s:path(path)
    let path = expand(s:home . '/' . a:path )
    return substitute(path, '\\', '/', 'g')
endfunc
".}}}1

" 插件分组 ----------------------------------------------------------------{{{1
let g:bundle_group    = {}
let s:plugin_subgroup = {}
let s:is_logfile = $filetype =~ 'messages' || expand('%:e') =~ 'log'

let g:bundle_group['basic']      = 1
let g:bundle_group['colortheme'] = 1

if !s:is_logfile
    let g:bundle_group['editor']     = 1
    let g:bundle_group['ft_enhance'] = 1
    let g:bundle_group['textobj']    = 1
    let g:bundle_group['developer']  = 1
endif

" basic group -------------------------------------------------------------{{{2
if has_key(g:bundle_group, 'basic')
    let s:plugin_subgroup['one']        = 1
    let s:plugin_subgroup['fern']       = 1
    let s:plugin_subgroup['commentary'] = 1
    let s:plugin_subgroup['barbaric']   = 1
    let s:plugin_subgroup['motion']     = 1
    let s:plugin_subgroup['choosewin']  = 1

    if !has('patch-8.1.0360')
        let s:plugin_subgroup['diffenhance']  = 1
    endif
endif
".}}}2

" colortheme group --------------------------------------------------------{{{2
if has_key(g:bundle_group, 'colortheme')
    let s:plugin_subgroup['hexokinase'] = 1
    " let s:plugin_subgroup['airline']    = 1
    let s:plugin_subgroup['lightline']  = 1
endif
".}}}2

" editor group ------------------------------------------------------------{{{2
if has_key(g:bundle_group, 'editor')
    " let s:plugin_subgroup['indentline']   = 1
    let s:plugin_subgroup['sleuth']       = 1
    let s:plugin_subgroup['tabular']      = 1
    let s:plugin_subgroup['repeat']       = 1
    let s:plugin_subgroup['surround']     = 1
    let s:plugin_subgroup['matchup']      = 1
    let s:plugin_subgroup['unimpaired']   = 1
    let s:plugin_subgroup['multicursor']  = 1
    let s:plugin_subgroup['nginx']        = 1
endif
".}}}2

" ft_enhance group --------------------------------------------------------{{{2
if has_key(g:bundle_group, 'ft_enhance')
    let s:plugin_subgroup['cpp-enhance-hi'] = 1
    let s:plugin_subgroup['cppman']         = 1
    let s:plugin_subgroup['pysynenhance']   = 1
    let s:plugin_subgroup['rustsynenhance'] = 1
    let s:plugin_subgroup['orgmode']        = 1
endif
".}}}2

" textobj group -----------------------------------------------------------{{{2
if has_key(g:bundle_group, 'textobj')
    " Use vim-init/plugin/indent-object.vim instead
    " let s:plugin_subgroup['to-indent']    = 1

    let s:plugin_subgroup['to-syntax']    = 1
    let s:plugin_subgroup['to-function']  = 1
    let s:plugin_subgroup['to-parameter'] = 1
    let s:plugin_subgroup['to-python']    = 1
    let s:plugin_subgroup['to-uri']       = 1
endif
".}}}2

" developer group ----------------------------------------------------------{{{2
if has_key(g:bundle_group, 'developer')
    let s:plugin_subgroup['editorconfig'] = 1
    let s:plugin_subgroup['fugitive']     = 1
    let s:plugin_subgroup['signify']      = 1
    let s:plugin_subgroup['tags']         = 1
    let s:plugin_subgroup['preview']      = 1
    let s:plugin_subgroup['ale']          = 1
    let s:plugin_subgroup['echodoc']      = 1
    let s:plugin_subgroup['leaderf']      = 1
    let s:plugin_subgroup['ycm']          = 1
    let s:plugin_subgroup['snippets']     = 1
endif
".}}}2
".}}}1

" 插件安装 ----------------------------------------------------------------{{{1
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))

" basic group -------------------------------------------------------------{{{2
if has_key(g:bundle_group, 'basic')
    if has_key(s:plugin_subgroup, 'one')
        if !g:disable_all_plugin
            " Use the fork for better performance than 'rakr/vim-one', but have bug in switch color theme
            Plug 'mikewy0527/vim-one'
        endif
    endif

    if !s:is_logfile
        if has_key(s:plugin_subgroup, 'fern')
            Plug 'lambdalisue/fern.vim', { 'on': [] }
            Plug 'yuki-yano/fern-preview.vim', { 'on': [] }
        endif

        if has_key(s:plugin_subgroup, 'barbaric')
            Plug 'rlue/vim-barbaric', { 'on': [] }
        endif
    endif

    if has_key(s:plugin_subgroup, 'commentary')
        Plug 'tpope/vim-commentary'
    endif

    if has_key(s:plugin_subgroup, 'motion')
        " 全文快速移动，<leader><leader>f{char} 即可触发
        " Plug 'easymotion/vim-easymotion'

        " alternative
        Plug 'justinmk/vim-sneak'
    endif

    if has_key(s:plugin_subgroup, 'choosewin')
        " 使用 ALT+e 会在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
        Plug 't9md/vim-choosewin'
    endif

    if has_key(s:plugin_subgroup, 'diffenhance')
        Plug 'chrisbra/vim-diff-enhanced'
    endif
endif
".}}}2

" colortheme group --------------------------------------------------------{{{2
if has_key(g:bundle_group, 'colortheme')
    if !s:is_logfile
        if has_key(s:plugin_subgroup, 'hexokinase')
            Plug 'rrethy/vim-hexokinase', { 'for': ['css', 'html', 'javascript', 'vim'], 'do': 'make hexokinase' }
        endif
    endif

    if has_key(s:plugin_subgroup, 'airline')
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
    endif

    if has_key(s:plugin_subgroup, 'lightline')
        Plug 'itchyny/lightline.vim'
        Plug 'deponian/vim-lightline-whitespace'
    endif
endif
".}}}2

" editor group ------------------------------------------------------------{{{2
if has_key(g:bundle_group, 'editor')
    if has_key(s:plugin_subgroup, 'indentline')
        Plug 'Yggdroot/indentLine', { 'on': [] }
    endif

    if has_key(s:plugin_subgroup, 'tabular')
        Plug 'godlygeek/tabular', { 'on': 'Tabularize', 'for': ['markdown', 'conf', 'config', 'text'] }
    endif

    if has_key(s:plugin_subgroup, 'sleuth')
        Plug 'tpope/vim-sleuth'
    endif

    if has_key(s:plugin_subgroup, 'repeat')
        Plug 'tpope/vim-repeat'
    endif

    if has_key(s:plugin_subgroup, 'surround')
        Plug 'tpope/vim-surround'
        " Plug 'jiangmiao/auto-pairs'

        " Alternative
        " Plug 'machakann/vim-sandwich'
    endif

    if has_key(s:plugin_subgroup, 'matchup')
        Plug 'andymass/vim-matchup', { 'for': ['c', 'cpp', 'python', 'go', 'rust', 'sh', 'bash', 'make', 'cmake', 'json', 'vim'] }
    endif

    if has_key(s:plugin_subgroup, 'unimpaired')
        Plug 'tpope/vim-unimpaired'
    endif

    if has_key(s:plugin_subgroup, 'multicursor')
        Plug 'mg979/vim-visual-multi'
    endif

    if has_key(s:plugin_subgroup, 'nginx')
        Plug 'chr4/nginx.vim'
    endif
endif
".}}}2

" filetype group ----------------------------------------------------------{{{2
if has_key(g:bundle_group, 'ft_enhance')
    if has_key(s:plugin_subgroup, 'cpp-enhance-hi')
        Plug 'mikewy0527/vim-cpp-enhanced-highlight', { 'on': [], 'for': ['c', 'cpp'] }
    endif

    if has_key(s:plugin_subgroup, 'cppman')
        Plug 'mikewy0527/vim-cppman', { 'on': [], 'for': ['c', 'cpp'] }
    endif

    if has_key(s:plugin_subgroup, 'pysynenhance')
        " python 语法文件增强
        Plug 'vim-python/python-syntax', { 'on': [], 'for': ['python'] }
    endif

    if has_key(s:plugin_subgroup, 'rustsynenhance')
        " rust 语法增强
        Plug 'rust-lang/rust.vim', { 'on': [], 'for': 'rust' }
    endif

    if has_key(s:plugin_subgroup, 'orgmode')
        " vim org-mode
        Plug 'jceb/vim-orgmode', { 'on': [], 'for': 'org' }
    endif
endif
".}}}2

" textobj group -----------------------------------------------------------{{{2
if has_key(g:bundle_group, 'textobj')
    " 基础插件：提供让用户方便的自定义文本对象的接口
    Plug 'kana/vim-textobj-user'

    if has_key(s:plugin_subgroup, 'to-indent')
        " indent 文本对象：ii/ai 表示当前缩进，vii 选中当缩进，cii 改写缩进
        Plug 'kana/vim-textobj-indent'
    endif

    if has_key(s:plugin_subgroup, 'to-syntax')
        " 语法文本对象：iy/ay 基于语法的文本对象
        Plug 'kana/vim-textobj-syntax'
    endif

    if has_key(s:plugin_subgroup, 'to-function')
        " 函数文本对象：if/af 支持 c/c++/vim/java
        Plug 'kana/vim-textobj-function'
    endif

    if has_key(s:plugin_subgroup, 'to-parameter')
        " 参数文本对象：i,/a, 包括参数或者列表元素
        Plug 'sgur/vim-textobj-parameter'
    endif

    if has_key(s:plugin_subgroup, 'to-python')
        " 提供 python 相关文本对象，if/af 表示函数，ic/ac 表示类
        Plug 'bps/vim-textobj-python', { 'for': 'python' }
    endif

    if has_key(s:plugin_subgroup, 'to-uri')
        " 提供 uri/url 的文本对象，iu/au 表示
        Plug 'jceb/vim-textobj-uri'
    endif
endif
".}}}2

" developer group ---------------------------------------------------------{{{2
if has_key(g:bundle_group, 'developer')
    if has_key(s:plugin_subgroup, 'fugitive')
        Plug 'tpope/vim-fugitive', { 'on': [] }
    endif

    if has_key(s:plugin_subgroup, 'signify')
        " 用于在侧边符号栏显示 git/svn 的 diff, alternative of 'airblade/vim-gitgutter'
        Plug 'mhinz/vim-signify', { 'on': [] }
    endif

    if has_key(s:plugin_subgroup, 'editorconfig')
        Plug 'editorconfig/editorconfig-vim'
    endif

    if has_key(s:plugin_subgroup, 'tags')
        "set cscopetag
        "set cscopeprg='gtags-cscope'

        " for gtags
        let $GTAGSLABEL = 'native-pygments'
        let $GTAGSCONF  = '/home/walt/.globalrc'

        " 提供 ctags/gtags 后台数据库自动更新功能
        Plug 'ludovicchabant/vim-gutentags', { 'on': [] }

        " 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
        " 支持光标移动到符号名上：<leader>cg 查看定义，<leader>cs 查看引用
        Plug 'skywind3000/gutentags_plus', { 'on': [] }
    endif

    if has_key(s:plugin_subgroup, 'preview')
        " 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
        Plug 'skywind3000/vim-preview', { 'on': [], 'for': ['c', 'cpp', 'python', 'go', 'rust'] }
    endif

    if has_key(s:plugin_subgroup, 'ale')
        let g:ale_disable_lsp = 1
        " Plug 'dense-analysis/ale', { 'on': [], 'for': ['c', 'cpp'] }
        Plug 'dense-analysis/ale', { 'on': [] }
    endif

    if has_key(s:plugin_subgroup, 'echodoc')
        Plug 'Shougo/echodoc.vim', { 'on': [], 'for': ['c', 'cpp', 'python', 'go', 'rust'] }
    endif

    if has_key(s:plugin_subgroup, 'leaderf')
        " 如果 vim 支持 python 则启用  Leaderf
        if has('python') || has('python3')
            Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension', 'on': [] }
        endif
    endif

    if has_key(s:plugin_subgroup, 'ycm')
        Plug 'Valloric/YouCompleteMe', { 'do': 'python ./install.py --ninja --clang-completer --clangd-completer --go-completer --rust-completer', 'on': [] }
    endif

    if has_key(s:plugin_subgroup, 'snippets')
        Plug 'SirVer/ultisnips', { 'on': [] }
        Plug 'honza/vim-snippets', { 'on': [] }
    endif
endif
".}}}2

" 结束插件安装
call plug#end()
".}}}1

" 插件配置 ----------------------------------------------------------------{{{1

" commentary --------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'commentary')
    augroup vimplug_load_commentary
        autocmd!

        autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

        " Correct commenting on ssh config
        autocmd FileType dosini,sshconfig,sshdconfig setlocal commentstring=#%s
        autocmd FileType dosini,sshconfig,sshdconfig let b:commentary_format = &commentstring
    augroup end
endif
".}}}2

" fern --------------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'fern')
    function! OndemandLoadFern()
        if !s:is_logfile
            call plug#load('fern.vim')
            call plug#load('fern-preview.vim')
        endif
    endfunction

    if maparg('<Leader>lf', 'n') ==# ''
        nnoremap <Leader>lf :call OndemandLoadFern()<CR>
    endif

    " Disable netrw.
    let g:loaded_netrw             = 1
    let g:loaded_netrwPlugin       = 1
    let g:loaded_netrwSettings     = 1
    let g:loaded_netrwFileHandlers = 1

    function! s:hijack_directory() abort
        let path = expand('%:p')
        if !isdirectory(path)
            return
        endif
        bwipeout %
        execute printf('Fern %s', fnameescape(path))
    endfunction

    augroup vimplug_load_fern_hijack
        autocmd!
        autocmd BufEnter * ++nested call s:hijack_directory()
    augroup END

    " Custom settings and mappings.
    let g:fern#disable_default_mappings = 1

    function! FernInit() abort
        nmap <buffer><expr>
            \ <Plug>(fern-my-open-expand-collapse)
            \ fern#smart#leaf(
            \   "\<Plug>(fern-action-open:select)",
            \   "\<Plug>(fern-action-expand)",
            \   "\<Plug>(fern-action-collapse)",
            \ )
        nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
        nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
        nmap <buffer> n <Plug>(fern-action-new-path)
        nmap <buffer> d <Plug>(fern-action-remove)
        nmap <buffer> m <Plug>(fern-action-move)
        nmap <buffer> M <Plug>(fern-action-rename)
        nmap <buffer> h <Plug>(fern-action-hidden:toggle)
        nmap <buffer> r <Plug>(fern-action-reload)
        nmap <buffer> - <Plug>(fern-action-mark:toggle)
        nmap <buffer> b <Plug>(fern-action-open:split)
        nmap <buffer> v <Plug>(fern-action-open:vsplit)
        nmap <buffer> t <Plug>(fern-action-open:tabedit)
        nmap <buffer><nowait> < <Plug>(fern-action-leave)
        nmap <buffer><nowait> > <Plug>(fern-action-enter)
    endfunction

    augroup vimplug_load_fern_init
        autocmd!
        autocmd FileType fern call FernInit()
    augroup END

    function! s:fern_settings() abort
        nmap <silent> <buffer> p      <Plug>(fern-action-preview:toggle)
        nmap <silent> <buffer> <M-p>  <Plug>(fern-action-preview:auto:toggle)
        nmap <silent> <buffer> <M-d>  <Plug>(fern-action-preview:scroll:down:half)
        nmap <silent> <buffer> <M-u>  <Plug>(fern-action-preview:scroll:up:half)
        nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview) fern_preview#smart_preview("\<Plug>(fern-action-preview:close)", ":q\<CR>")
        nmap <silent> <buffer> q      <Plug>(fern-quit-or-close-preview)
    endfunction

    augroup vimplug_load_fern_settings
        autocmd!
        autocmd FileType fern call s:fern_settings()
    augroup END

    noremap <silent> <leader>f :Fern . -drawer -reveal=% -toggle -width=35<CR><C-w>=
endif
".}}}2

" sleuth ------------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'sleuth')
    let g:sleuth_neighbor_limit    = 7
    let g:sleuth_buf_max_readlines = 256
endif
".}}}2

" vim-diff-enhance --------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'diffenhance')
    " started In Diff-Mode set diffexpr (plugin not loaded yet)
    if &diff
        let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
    endif
endif
".}}}2

" editorconfig -------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'editorconfig')
    let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

    augroup vimplug_load_editorconfig
        autocmd!
        autocmd FileType gitcommit let b:EditorConfig_disable = 1
    augroup END
endif
".}}}2

" cpp-enhance-highlight ---------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'cpp-enhance-hi')
    let g:cpp_no_function_highlight                  = 0
    let g:cpp_class_scope_highlight                  = 1
    let g:cpp_member_variable_highlight              = 1
    let g:cpp_class_decl_highlight                   = 1
    let g:cpp_posix_standard                         = 1
    let g:cpp_experimental_simple_template_highlight = 1
    let g:cpp_concepts_highlight                     = 1
    let g:cpp_operator_highlight                     = 1
    let c_no_curly_error                             = 1
endif
".}}}2

" cppman ------------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'cppman')
    let g:cppman_open_mode  = 'auto'
    let g:cppman_no_keymaps = 0
endif
".}}}2

" sneak -------------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'sneak')
    let g:sneak#label = 1
endif
".}}}2

" hexokinase --------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'hexokinase')
    let g:Hexokinase_highlighters  = [ 'backgroundfull' ]
    let g:Hexokinase_optInPatterns = 'full_hex'
    let g:Hexokinase_ftEnabled     = ['css', 'html', 'javascript', 'vim']
endif
".}}}2

" indentline --------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'indentline')
    function! s:vimplug_load_indentline()
        if !s:is_logfile
            call plug#load('indentLine')
            autocmd! vimplug_load_indentline
            exec 'IndentLinesEnable'
        endif
    endfunction

    augroup vimplug_load_indentline
        autocmd!
        autocmd BufWinEnter * call s:vimplug_load_indentline()
    augroup END

    let g:indentLine_enabled             = 1
    let g:indentLine_leadingSpaceEnabled = 0
    " let g:indentLine_color_term          = 8

    " indentLine character setting:
    " indentLine_char: all indent levels have same distinct character.
    " each indent level has a distinct character.
    let g:indentLine_char      = '│'
    " let g:indentLine_char_list = ['⎸', '│', '|', '¦', '┆', '┊']

    " customize conceal color
    let g:indentLine_color_term = 237
    let g:indentLine_color_gui  = '#3a3a3a'
endif
".}}}2

" tabular -----------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'tabular')
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:\zs<CR>
    vmap <Leader>a: :Tabularize /:\zs<CR>
    inoremap <silent> <Bar> <Bar><Esc>:call <SID>TableAlign()<CR>a
    " inoremap <silent> :     :<Esc>:call <SID>SymbolAlign(':')<CR>a
    " inoremap <silent> =     =<Esc>:call <SID>SymbolAlign('=')<CR>a

    function! s:SymbolAlign(aa)
        let p = '^.*\s'.a:aa.'\s.*$'
        if exists(':Tabularize') && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
            let column = strlen(substitute(getline('.')[0:col('.')],'[^'.a:aa.']','','g'))
            let position = strlen(matchstr(getline('.')[0:col('.')],'.*'.a:aa.':\s*\zs.*'))
            exec 'Tabularize/'.a:aa.'/l1'
            normal! 0
            call search(repeat('[^'.a:aa.']*'.a:aa,column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
        endif
    endfunction

    function! s:TableAlign()
        let p = '^\s*|\s.*\s|\s*$'
        if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
            let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
            let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
            exec 'Tabularize/|/l1'
            normal! 0
            call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
        endif
    endfunction
endif
".}}}2

" barbaric ----------------------------------------------------------------{{{2
" Insert/Normal 中文输入自动切换
if has_key(s:plugin_subgroup, 'barbaric')
    function! OndemandLoadIMSwitcher()
            call plug#load('vim-barbaric')
    endfunction

    " The IME to invoke for managing input languages (macos, fcitx, ibus, xkb-switch)
    let g:barbaric_ime = 'fcitx'

    " The input method for Normal mode (as defined by `xkbswitch -g`, `ibus engine`, or `xkb-switch -p`)
    let g:barbaric_default = '-c'

    " The fcitx-remote binary (to distinguish between fcitx and fcitx5)
    let g:barbaric_fcitx_cmd = 'fcitx5-remote'

    if maparg('<Leader>im', 'n') ==# ''
        nnoremap <Leader>im :call OndemandLoadIMSwitcher()<CR>
    endif
endif
".}}}2

" choosewin ---------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'choosewin')
    " 使用 ALT+E 来选择窗口
    nmap <m-e> <Plug>(choosewin)
endif
".}}}2

" fugitive and signify ----------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'fugitive')
    function! OndemandLoadFugitive()
        if system('git rev-parse --is-inside-work-tree') =~ 'true'
            if exists('g:loaded_fugitive')
                return
            endif

            call plug#load('vim-fugitive')
            call FugitiveDetect(expand('%:p'))

            if has_key(s:plugin_subgroup, 'signify')
                call plug#load('vim-signify')
                call sy#start()
            endif

            call lightline#disable()
            call lightline#enable()
        endif
    endfunction

    if maparg('<Leader><F5>', 'n') ==# ''
        nnoremap <Leader><F5> :call OndemandLoadFugitive()<CR>
    endif
endif

if has_key(s:plugin_subgroup, 'signify')
    " signify 调优
    set updatetime=100

    let g:signify_vcs_list               = ['git', 'svn']
    let g:signify_sign_add               = '+'
    let g:signify_sign_delete            = '_'
    let g:signify_sign_delete_first_line = '‾'
    let g:signify_sign_change            = '~'
    let g:signify_sign_changedelete      = g:signify_sign_change

    " git 仓库使用 histogram 算法进行 diff
    let g:signify_vcs_cmds = {
            \ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
        \}
endif
".}}}2

" ctags/gtags -------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'tags')
    function! OndemandLoadGtags()
        call plug#load('vim-gutentags')
        call plug#load('gutentags_plus')
    endfunction

    if maparg('<Leader>lg', 'n') ==# ''
        nnoremap <Leader>lg :call OndemandLoadGtags()<CR>
    endif

    " 自动生成 ctags/gtags，并提供自动索引功能
    " 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
    " 详细用法见：https://zhuanlan.zhihu.com/p/36279445

    " gutentags debug
    " let g:gutentags_define_advanced_commands = 1
    " let g:gutentags_trace                    = 1

    " 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
    let g:gutentags_project_root  = ['.root', '.git', '.svn', '.hg', '.project']
    let g:gutentags_ctags_tagfile = '.tags'

    " 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
    let s:vim_tags            = expand('~/.cache/tags')
    let g:gutentags_cache_dir = s:vim_tags

    if !isdirectory(s:vim_tags)
        silent! call mkdir(s:vim_tags, 'p')
    endif

    " 默认禁用自动生成
    let g:gutentags_modules = []

    " 如果有 ctags 可执行就允许动态生成 ctags 文件
    if executable('ctags')
        let g:gutentags_modules += ['ctags']

        " 设置 ctags 的参数
        let g:gutentags_ctags_extra_args = []
        let g:gutentags_ctags_extra_args += ['--fields=+niazS', '--extras=+q']
        let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

        " 使用 universal-ctags 的话需要下面这行，请反注释
        let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
    endif

    " 如果有 gtags 可执行就允许动态生成 gtags 数据库
    if executable('gtags') && executable('gtags-cscope')
        let g:gutentags_modules += ['gtags_cscope']
    endif

    " 禁止 gutentags 自动链接 gtags 数据库
    let g:gutentags_auto_add_gtags_cscope = 0

    " gutentags_plus setting
    let g:gutentags_plus_switch = 1
    let g:gutentags_plus_nomap  = 1

    noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr>
    noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
    noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
    noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
    noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
    noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
    noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
    noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
    noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>
    noremap <silent> <leader>gz :GscopeFind z <C-R><C-W><cr>
endif
".}}}2

"preview ------------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'preview')
    noremap <m-u> :PreviewScroll -1<cr>
    noremap <m-d> :PreviewScroll +1<cr>
    inoremap <m-u> <c-\><c-o>:PreviewScroll -1<cr>
    inoremap <m-d> <c-\><c-o>:PreviewScroll +1<cr>

    augroup vimplug_load_vimpreview
        " Clear all existing autocommands in this group
        autocmd!

        autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
        autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
    augroup end

    noremap <F4> :PreviewSignature!<cr>
    inoremap <F4> <c-\><c-o>:PreviewSignature!<cr>
endif
".}}}2

" matchup -----------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'matchup')
    let g:matchup_motion_enabled = 0
    let g:matchup_text_obj_enabled = 0
    let g:matchup_delim_noskips = 2
    let g:matchup_matchparen_deferred = 1
    let g:matchup_matchparen_offscreen = { 'method': 'popup' }
endif
".}}}2

" airline -----------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'airline')
    let g:airline_symbols_ascii                   = 1
    let g:airline_left_sep                        = ''
    let g:airline_left_alt_sep                    = ''
    let g:airline_right_sep                       = ''
    let g:airline_right_alt_sep                   = ''
    let g:airline_powerline_fonts                 = 0
    let g:airline_exclude_preview                 = 1
    let g:airline_section_b                       = '%n'
    let g:airline_theme                           = 'deus'
    let g:airline#extensions#branch#enabled       = 1
    let g:airline#extensions#syntastic#enabled    = 1
    let g:airline#extensions#fugitiveline#enabled = 1
    let g:airline#extensions#csv#enabled          = 1
    let g:airline#extensions#vimagit#enabled      = 1
endif
".}}}2

" lightline ---------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'lightline')
    let g:lightline = {
        \   'colorscheme': 'one',
        \   'active': {
        \     'left': [
        \       ['mode', 'paste'],
        \       ['gitbranch', 'readonly', 'filename', 'modified']
        \     ],
        \     'right': [
        \       [ 'lineinfo' ],
        \       [ 'percent' ],
        \       [ 'fileformat', 'fileencoding', 'filetype' ],
        \       [ 'whitespace' ]
        \     ]
        \   },
        \   'component_function': {
        \     'gitbranch': 'fugitive#head',
        \     'filename' : 'LightlineFilename'
        \   },
        \   'component_expand': {
        \     'whitespace': 'lightline#whitespace#check'
        \   },
        \   'component_type': {
        \     'whitespace': 'warning'
        \   }
        \ }

    let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
    let s:palette.tabline.tabsel = [['#282C34', '#5F87D7', 235, 68]]

    function! LightlineFilename()
        let s:root = fnamemodify(get(b:, 'git_dir'), ':h')
        let s:path = expand('%:p')
        if s:path[:len(s:root)-1] ==# s:root
            return s:path[len(s:root)+1:]
        endif
        return substitute(s:path, $HOME, "~", "")
    endfunction

    let g:whitespace#skip_check_ft = {'make': ['mixed', 'inconsistent']}
    let g:whitespace#c_like_langs = [ 'arduino', 'c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php' ]
endif
".}}}2

" ale ---------------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'ale')
    function! OndemandLoadALE()
        if !exists('g:ale_enabled')
            call plug#load('ale')
            let g:ale_enabled = 0
            exec 'ALEToggle'
        endif
        exec 'ALEToggle'
    endfunction

    let g:ale_lint_on_enter      = 0
    let g:ale_linters_explicit   = 1
    let g:ale_hover_to_preview   = 1
    let g:ale_sign_column_always = 1
    let g:ale_set_highlights     = 0

    " 设定延迟和提示信息
    let g:ale_completion_delay = 500
    let g:ale_echo_delay       = 20
    let g:ale_lint_delay       = 500
    let g:ale_echo_msg_format  = '[%linter%] %code: %%s'

    " 设定检测的时机：normal 模式文字改变，或者离开 insert模式
    " 禁用默认 INSERT 模式下改变文字也触发的设置，太频繁外，还会让补全窗闪烁
    let g:ale_lint_on_text_changed = 'normal'
    let g:ale_lint_on_insert_leave = 1

    " 在 linux/mac 下降低语法检查程序的进程优先级（不要卡到前台进程）
    if has('win32') == 0 && has('win64') == 0 && has('win32unix') == 0
        let g:ale_command_wrapper = 'nice -n5'
    endif

    " 允许 airline 集成
    " let g:airline#extensions#ale#enabled = 1

    let g:ale_sign_error                 = '>>'
    let g:ale_sign_warning               = '!!'
    let g:ale_echo_msg_error_str         = 'E'
    let g:ale_echo_msg_warning_str       = 'W'
    let g:ale_echo_msg_format            = '[%linter%] %s [%severity%]'

    " Check by makefile
    let g:ale_c_always_make    = 0
    let g:ale_c_parse_makefile = 1

    " Check by compile_command.json
    let g:ale_c_parse_compile_commands = 1

    " 编辑不同文件类型需要的语法检查器
    let g:ale_linters = {
        \ 'c'     : ['clang', 'cppcheck', 'splint'],
        \ 'cpp'   : ['clang', 'cppcheck', 'splint'],
        \ 'go'    : ['gopls', 'gofmt', 'golint', 'govet'],
        \ 'python': ['flake8', 'mypy', 'pylint', 'pyright'],
        \ 'rust'  : ['rustc', 'cargo', 'rls'],
        \ 'sh'    : ['bashate', 'shell', 'shellcheck'],
        \ 'tex'   : ['texlab'],
        \ 'zsh'   : ['bashate', 'shell', 'shellcheck'],
        \ }

    let g:ale_fixers = {
        \ 'c'     : ['clang-format'],
        \ 'cpp'   : ['clang-format'],
        \ 'go'    : ['gofmt', 'goimports', 'gomod'],
        \ 'python': ['autopep8', 'yapf', 'isort'],
        \ 'rust'  : ['rustfmt'],
        \ 'sh'    : ['shfmt'],
        \ 'zsh'   : ['shfmt'],
        \ }

    " 获取 pylint, flake8 的配置文件，在 vim-init/tools/conf 下面
    function s:lintcfg(name)
        let conf  = s:path('tools/conf/')
        let path1 = conf . a:name
        let path2 = expand('~/.vim/linter/'. a:name)
        if filereadable(path2)
            return path2
        endif
        return shellescape(filereadable(path2)? path2 : path1)
    endfunc

    " 设置 flake8/pylint 的参数
    let g:ale_python_flake8_options = '--conf='.s:lintcfg('flake8.conf')
    let g:ale_python_pylint_options = '--rcfile='.s:lintcfg('pylint.conf')
    let g:ale_python_pylint_options .= ' --disable=W'

    let g:ale_c_cc_options         = '-std=c2x -Wall'
    let g:ale_cpp_cc_options       = '-std=c++2a -Wall'
    let g:ale_c_clang_options      = '-Wall -O2 -std=c2x'
    let g:ale_cpp_clang_options    = '-Wall -O2 -std=c++2a -x c++'
    let g:ale_c_gcc_options        = '-Wall -O2 -std=c2x'
    let g:ale_cpp_gcc_options      = '-Wall -O2 -std=c++2a -x c++'
    let g:ale_c_cppcheck_options   = ''
    let g:ale_cpp_cppcheck_options = ''

    let g:ale_linters.text          = ['textlint', 'write-good', 'languagetool']
    let g:ale_sh_shellcheck_options = '-x'

    if maparg('<Leader><F6>', 'n') ==# ''
        nnoremap <Leader><F6> :call OndemandLoadALE()<CR>
    endif
endif
".}}}2

" echodoc -----------------------------------------------------------------{{{2
" 搭配 YCM/deoplete 在底部显示函数参数
if has_key(s:plugin_subgroup, 'echodoc')
    set noshowmode
    let g:echodoc#enable_at_startup = 1
endif
".}}}2

" LeaderF -----------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'leaderf')
    " 如果 vim 支持 python 则启用  Leaderf
    if has('python') || has('python3')
        " CTRL+p 打开文件模糊匹配
        let g:Lf_ShortcutF = '<c-p>'

        " ALT+n 打开 buffer 模糊匹配
        let g:Lf_ShortcutB = '<m-n>'

        " CTRL+n 打开最近使用的文件 MRU，进行模糊匹配
        noremap <c-n> :LeaderfMru<cr>

        " ALT+p 打开函数列表，按 i 进入模糊匹配，ESC 退出
        noremap <m-p> :LeaderfFunction!<cr>

        " ALT+SHIFT+p 打开 tag 列表，i 进入模糊匹配，ESC退出
        noremap <m-P> :LeaderfBufTag!<cr>

        " ALT+n 打开 buffer 列表进行模糊匹配
        noremap <m-n> :LeaderfBuffer<cr>

        " ALT+m 全局 tags 模糊匹配
        noremap <m-m> :LeaderfTag<cr>

        " 最大历史文件保存 2048 个
        let g:Lf_MruMaxFiles = 2048
        " let g:Lf_Gtagslabel  = 'native-pygments'

        " ui 定制
        let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

        " 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
        let g:Lf_RootMarkers          = ['.project', '.root', '.svn', '.git']
        let g:Lf_WorkingDirectoryMode = 'Ac'
        let g:Lf_WindowHeight         = 0.30
        let g:Lf_CacheDirectory       = expand('~/.vim/cache')

        " 显示绝对路径
        let g:Lf_ShowRelativePath = 0

        " 隐藏帮助
        let g:Lf_HideHelp = 1

        " 模糊匹配忽略扩展名
        let g:Lf_WildIgnore = {
                \ 'dir' : ['.svn','.git','.hg'],
                \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
            \ }

        " MRU 文件忽略扩展名
        let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
        let g:Lf_StlColorscheme = 'powerline'

        " 禁用 function/buftag 的预览功能，可以手动用 p 预览
        let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

        " 使用 ESC 键可以直接退出 leaderf 的 normal 模式
        let g:Lf_NormalMap = {
                \ "File"    : [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
                \ "Buffer"  : [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
                \ "Mru"     : [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
                \ "Tag"     : [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
                \ "BufTag"  : [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
                \ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
            \ }
    else
        " 忽略默认键位
        let g:ctrlp_map = ''

        " 模糊匹配忽略
        let g:ctrlp_custom_ignore = {
                \ 'dir' : '\v[\/]\.(git|hg|svn)$',
                \ 'file': '\v\.(exe|so|dll|mp3|wav|sdf|suo|mht)$',
                \ 'link': 'some_bad_symbolic_links',
            \ }

        " 项目标志
        let g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
        let g:ctrlp_working_path = 0

        " CTRL+p 打开文件模糊匹配
        noremap <c-p> :CtrlP<cr>

        " CTRL+n 打开最近访问过的文件的匹配
        noremap <c-n> :CtrlPMRUFiles<cr>

        " ALT+p 显示当前文件的函数列表
        noremap <m-p> :CtrlPFunky<cr>

        " ALT+n 匹配 buffer
        noremap <m-n> :CtrlPBuffer<cr>
    endif
endif
".}}}2

" YouCompleteMe -----------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'ycm')
    let g:YouCompleteMeLazyLoaded = 0
    function! LazyLoadingYMC()
        if g:YouCompleteMeLazyLoaded == 0
            let g:YouCompleteMeLazyLoaded = 1
            call plug#load('YouCompleteMe') | call youcompleteme#Enable()
        endif
    endfunction
    augroup vimplug_load_ycm
        autocmd!

        autocmd BufWinEnter * call timer_start(1, {id->execute('call LazyLoadingYMC()')} )
    augroup end

    " 禁用预览功能：扰乱视听
    let g:ycm_add_preview_to_completeopt       = 0
    let g:ycm_disable_for_files_larger_than_kb = 5000

    " 禁用诊断功能：我们用前面更好用的 ALE 代替
    let g:ycm_show_diagnostics_ui                           = 0
    let g:ycm_server_log_level                              = 'info'
    let g:ycm_min_num_identifier_candidate_chars            = 2
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_complete_in_strings                           = 1
    let g:ycm_disable_signature_help                        = 1
    let g:ycm_auto_hover                                    = ''
    let g:ycm_key_list_stop_completion                      = ['<C-y>', '<CR>']

    noremap <c-z> <NOP>
    nmap <leader>D <plug>(YCMHover)
    set completeopt=menu,menuone,noselect

    " 两个字符自动触发语义补全
    let g:ycm_semantic_triggers =  {
            \ 'c,cpp,python,java,go,erlang,perl' : ['re!\w{2}'],
            \ 'cs,lua,javascript'                : ['re!\w{2}'],
        \ }

    " Ycm 白名单（非名单内文件不启用 YCM），避免打开个 1MB 的 txt 分析半天
    let g:ycm_filetype_whitelist = {
            \ "c"          : 1,
            \ "cpp"        : 1,
            \ "objc"       : 1,
            \ "objcpp"     : 1,
            \ "python"     : 1,
            \ "java"       : 1,
            \ "javascript" : 1,
            \ "coffee"     : 1,
            \ "vim"        : 1,
            \ "go"         : 1,
            \ "cs"         : 1,
            \ "lua"        : 1,
            \ "perl"       : 1,
            \ "perl6"      : 1,
            \ "php"        : 1,
            \ "ruby"       : 1,
            \ "rust"       : 1,
            \ "erlang"     : 1,
            \ "asm"        : 1,
            \ "nasm"       : 1,
            \ "masm"       : 1,
            \ "tasm"       : 1,
            \ "asm68k"     : 1,
            \ "asmh8300"   : 1,
            \ "asciidoc"   : 1,
            \ "make"       : 1,
            \ "cmake"      : 1,
            \ "html"       : 1,
            \ "css"        : 1,
            \ "less"       : 1,
            \ "json"       : 1,
            \ "cson"       : 1,
            \ "typedscript": 1,
            \ "haskell"    : 1,
            \ "lhaskell"   : 1,
            \ "lisp"       : 1,
            \ "scheme"     : 1,
            \ "sdl"        : 1,
            \ "sh"         : 1,
            \ "zsh"        : 1,
            \ "bash"       : 1,
            \ "man"        : 1,
            \ "matlab"     : 1,
            \ "conf"       : 1,
            \ "config"     : 1,
        \ }

    let g:ycm_filetype_blacklist = {
            \ 'text'     : 1,
            \ 'log'      : 1,
            \ 'man'      : 1,
            \ 'markdown' : 1,
            \ 'php'      : 1,
            \ 'tagbar'   : 1,
            \ 'notes'    : 1,
            \ 'netrw'    : 1,
            \ 'unite'    : 1,
            \ 'vimwiki'  : 1,
            \ 'pandoc'   : 1,
            \ 'infolog'  : 1,
            \ 'leaderf'  : 1,
            \ 'mail'     : 1
        \ }
endif
".}}}2

" snippets ---------------------------------------------------------------{{{2
if has_key(s:plugin_subgroup, 'snippets')
    function! OndemandLoadSnippets()
        call plug#load('ultisnips')
        call plug#load('vim-snippets')
    endfunction

    if maparg('<Leader>lu', 'n') ==# ''
        nnoremap <Leader>lu :call OndemandLoadSnippets()<CR>
    endif

    function! g:UltiSnips_Complete()
        call UltiSnips#ExpandSnippet()
        if g:ulti_expand_res == 0
            if pumvisible()
                return "\<C-n>"
            else
                call UltiSnips#JumpForwards()
                if g:ulti_jump_forwards_res == 0
                    return "\<TAB>"
                endif
            endif
        endif
        return ""
    endfunction

    function! g:UltiSnips_Reverse()
        call UltiSnips#JumpBackwards()
        if g:ulti_jump_backwards_res == 0
            return "\<C-P>"
        endif

        return ""
    endfunction


    if !exists("g:UltiSnipsExpandTrigger")
        let g:UltiSnipsExpandTrigger = '<Leader><Tab>'
    endif

    if !exists("g:UltiSnipsJumpForwardTrigger")
        let g:UltiSnipsJumpForwardTrigger = "<tab>"
    endif

    if !exists("g:UltiSnipsJumpBackwardTrigger")
        let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"
    endif

    autocmd InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
    autocmd InsertEnter * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"
endif
".}}}2
".}}}1

" vim: set fdl=0 fdm=marker:
