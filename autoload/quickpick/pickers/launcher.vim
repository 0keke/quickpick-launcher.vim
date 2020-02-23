function! quickpick#pickers#launcher#show(...) abort
    let id = quickpick#create({
        \   'on_change': function('s:on_change'),
        \   'on_accept': function('s:on_accept'),
        \   'items': s:get_launcher(0),
        \ })
    call quickpick#show(id)
    return id
endfunction

let s:config_file = get(g:, 'quickpick_launcher_file', '~/.quickpick-launcher')

function! s:get_launcher(refresh) abort
    if !exists('s:launcher') || a:refresh
        let l:file = fnamemodify(expand(s:config_file), ':p')
        let s:list = filereadable(file) ? filter(map(readfile(file), 'split(iconv(v:val, "utf-8", &encoding), "\\t\\+")'), 'len(v:val) > 0 && v:val[0]!~"^#"') : []

        let l:idx = range(len(s:list))
        let s:items =[]
        for l:i in l:idx
            call add(s:items, {'label': s:list[i][0], 'user_data': s:list[i][1]})
        endfor

        let s:items += [{'label': "--edit-menu--", 'user_data': printf("split %s", s:config_file)}]
    endif
    return s:items
endfunction

function! s:on_change(id, action, searchterm) abort
    let searchterm = tolower(a:searchterm)
    let items = empty(trim(searchterm)) ? s:get_launcher(0) : filter(copy(s:get_launcher(0)), {item-> stridx(tolower(v:val['label']), searchterm) > -1})
    call quickpick#set_items(a:id, items)
endfunction

function! s:on_accept(id, action, data) abort
    call quickpick#close(a:id)
    let cmd = a:data['items'][0]['user_data']
    if cmd =~ '^!'
        silent execute cmd
        redraw!
    else
        execute cmd
    endif
endfunction
