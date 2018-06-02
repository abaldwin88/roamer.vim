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

let roamer_version = system("roamer --version")
let roamer_major = roamer_version[0]
let roamer_minor = roamer_version[2]
let roamer_patch = roamer_version[4]
if roamer_major == 0 && roamer_minor < 3
  echoerr 'Required roamer version is 0.3.0 or greater'
endif

" `.v.roamer` is for a roamer sessions started inside vim

autocmd BufWriteCmd *.v.roamer call s:writeRoamer()
function! s:writeRoamer()
  let dir = shellescape(@%[:-10])
  silent execute 'write !roamer --raw-in --path '. dir
  silent execute "%!roamer --raw-out --path ". dir
  set nomodified
endfunction

autocmd BufEnter *.v.roamer call s:enterRoamer()
function! s:enterRoamer()
  let dir = fnameescape(@%[:-10])
  silent exec 'cd '. dir
endfunction

function! roamer#openWindow(dir)
    if !isdirectory(a:dir)
        return
    endif

    silent exec 'cd '. fnameescape(a:dir)

    let name = fnameescape(a:dir.'.v.roamer')
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
