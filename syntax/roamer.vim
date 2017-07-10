if exists("b:current_syntax")
  finish
endif

syntax region roamerFile start="\v^" end="\v[^\/].\ze\|" oneline
syntax region roamerDirectory start="\v^" end="\v\/" oneline
syntax match roamerDigest "\v[a-zA-Z0-9]*$" conceal
syntax match roamerDivider "\v(\|)" conceal
syntax match roamerComment "\v#.*$"

highlight link roamerDirectory Directory
highlight link roamerFile Normal
highlight link roamerDivider Type
highlight link roamerDigest Type
highlight link roamerComment Comment

" Force vim to sync at least x lines. This solves the multiline comment not
" being highlighted issue
syn sync minlines=100

let b:current_syntax = "roamer"
