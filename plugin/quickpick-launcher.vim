if exists('g:quickpick_launcher')
    finish
endif
let g:quickpick_launcher = 1

command! Plauncher call quickpick#pickers#launcher#show()
nnoremap <plug>(quickpick-launcher) :<c-u>Plauncher<cr>
if !hasmapto('<plug>(quickpick-launcher)')
  nmap <c-e> <plug>(quickpick-launcher)
endif
