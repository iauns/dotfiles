" MacVim specific settings (getting rid of the various
" menu items in mac vim). Most of these keyboard bindings have to deal
" with dvorak.
if has("mac") || has("macunix")
  " Get rid of the Select All key. Interferes with keyboard bindings.
  macm Edit.Select\ All key=<nop>
  macm File.New\ Tab    key=<nop>
  macm File.Open\.\.\.  key=<nop>
  macm File.Save        key=<D-o>
  macm File.Print       key=<nop>
  "macm MacVim.Hide\ MacVim key=<nop>
  
  macm Edit.Find.Find\ Next key=<nop>

  nnoremap <D-r> :maca _cycleWindowsBackwards:<CR> 
  nnoremap <D-g> :maca _cycleWindows:<CR> 
  inoremap <D-G> :maca _cycleWindows:<CR>
endif

