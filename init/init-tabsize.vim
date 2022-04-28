"======================================================================
"
" init-tabsize.vim - 大部分人对 tabsize 都有自己的设置，改这里即可
"
" Created by skywind on 2018/05/30
" Last Modified: 2018/05/30 22:05:44
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :


"----------------------------------------------------------------------
" 默认缩进模式（可以后期覆盖）
"----------------------------------------------------------------------

" 设置缩进宽度
set shiftwidth=4

" 禁止展开 tab (noexpandtab)
set noexpandtab

" 如果后面设置了 expandtab 那么展开 tab 为多少字符
set softtabstop=4

augroup PythonTab
    autocmd!
    " 如果你需要 python 里用 tab，那么反注释下面这行字，否则vim会在打开py文件
    " 时自动设置成空格缩进。
    "autocmd FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab
augroup END
