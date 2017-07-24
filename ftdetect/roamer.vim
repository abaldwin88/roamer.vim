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
