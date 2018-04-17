autocmd BufNewFile,BufRead *.roamer set filetype=roamer
autocmd BufRead * call s:Roamer()
function! s:Roamer()
  if !empty(&filetype)
    return
  endif

  let line = getline(1)
  if line =~ "^#!.*roamer"
    setfiletype roamer
  endif
endfunction
setlocal conceallevel=2

"TODO:  Might need to differentiate between roamer started in/outside vim
autocmd BufWriteCmd *.roamer call s:writeRoamer()
function! s:writeRoamer()
  let dir = shellescape(@%[:-8])
  silent execute 'write !roamer --raw-in --path '. dir
  silent execute "%!roamer --raw-out --path ". dir
  set nomodified
endfunction

function! roamer#openWindow(dir)
    if !isdirectory(a:dir)
        return
    endif

    let name = fnameescape(a:dir.'.roamer')
    if bufnr(name) > 0
      silent exec 'bwipeout '. bufnr(name)
    endif

    silent execute "%!roamer --raw-out --path ". shellescape(a:dir)
    silent exec 'file '. fnameescape(name)

    setlocal buftype=acwrite
    setlocal bufhidden=hide
    setlocal noswapfile
    set nomodified
    "TODO: AGB 2018-03-25 ~ This should be handled by setting the filename
    "                       Not sure why this is necessary
    setfiletype roamer
    setlocal conceallevel=2
endfunction


if !exists("g:RoamerHijackNetrw")
  let g:RoamerHijackNetrw = 1
endif


if g:RoamerHijackNetrw
  let g:NERDTreeHijackNetrw = 0
  augroup RoamerHijackNetrw
    autocmd VimEnter * silent! autocmd! FileExplorer
    au BufEnter,VimEnter * call roamer#openWindow(expand("<amatch>"))
  augroup END
endif
