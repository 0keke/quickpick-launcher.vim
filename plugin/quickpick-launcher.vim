if exists('g:quickpick_launcher')
  finish
endif
let g:quickpick_launcher = 1

command! Plauncher call quickpick#pickers#launcher#open()
nnoremap <plug>(quickpick-launcher) :<c-u>Plauncher<cr>

" vim: tabstop=2 shiftwidth=2 expandtab
