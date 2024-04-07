" Plugin => surround.vim

" Annotate strings with gettext
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>
