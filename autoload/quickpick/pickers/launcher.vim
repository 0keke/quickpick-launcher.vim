function! quickpick#pickers#launcher#open(...) abort
  call quickpick#open({
        \ 'items': s:get_items(),
        \ 'on_accept': function('s:on_accept'),
        \})
endfunction

let s:config_file = get(g:, 'quickpick_launcher_file', '~/.quickpick-launcher')

function! s:get_items() abort
  let file = fnamemodify(expand(s:config_file), ':p')
  let s:list = filereadable(file) ? filter(map(readfile(file), 'split(iconv(v:val, "utf-8", &encoding), "\\t\\+")'), 'len(v:val) > 0 && v:val[0]!~"^#"') : []
  let s:list += [["--edit-menu--", printf("split %s", s:config_file)]]
  return map(copy(s:list), 'v:val[0]')
endfunction

function! s:on_accept(data, ...) abort
  let lines = filter(copy(s:list), "v:val[0] == a:data['items'][0]")
  call quickpick#close()
  if len(lines) > 0 && len(lines[0]) > 1
    let cmd = lines[0][1]
    if cmd =~ '^!'
      silent exe cmd
    else
      exe cmd
    endif
  endif
endfunction

" vim: tabstop=2 shiftwidth=2 expandtab
