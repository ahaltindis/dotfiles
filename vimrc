" -------------------------------------------------
"   ahaltindis. <ahaltindis@gmail.com>
"   http://ahmt.me
"   vimrc
"   Last changed: 2015 June 15
" -------------------------------------------------
" Environment
" -------------------------------------------------
"	" Setup Bundle Support
"	" -----------------------------------------
"	   " Pathogen settings
	   call pathogen#runtime_append_all_bundles()
	   call pathogen#helptags()
	   filetype plugin indent on
"	" -----------------------------------------
	   filetype on
           syntax on
	" ----------------------------------------
	" Colors
	" ---------------------------------------
	   " This line for xterm to show colors proper.
	   if &term=~ "xterm"
	   	set t_Co=256
	   endif

	   "If gvim and vim have different colors
	   "if has('gui_running')
	   "	   set background=light
	   "else
	   	   set background=dark
	   "endif
	   
	   let g:solarized_visibility="low"
	   syntax enable 
	   colorscheme solarized
	" ---------------------------------------- 
	" Directories
	" ----------------------------------------
	   set backup
	   set backupdir=/tmp/
	   set directory=/tmp/
	" ----------------------------------------
	" Environment
	" ----------------------------------------
	   set nocompatible     " leave vi compatibility mode
	   set encoding=utf-8   " unicode encoding
	   set title            " show title in terminal
	" ----------------------------------------
	" Virtual Environment
	" ----------------------------------------
        " Add the virtualenv's site-packages to vim path
          py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
" -----------------------------------------------
"  Vim UI
" -----------------------------------------------
        " Location Indicators
	" ---------------------------------------
	   set nocursorcolumn           " no cursor highlight
	   set cursorline               " set cursor line highlight
	   set number                   " show line numbers
	   set numberwidth=5            " line numbers digit
	   v:vimrc>702 ? set relativenumber " use relative line numbers
	" ---------------------------------------
	" Screen Drawing
	" ---------------------------------------
	   set linespace=0
	   set ttyfast
	" ---------------------------------------
	" Movement
	" ---------------------------------------
	   set nostartofline
	   set scrolloff=5
	" ---------------------------------------
	" Status Indicator
	" ---------------------------------------
	   set showcmd
	   set showmode
	   set laststatus=2
	   set visualbell
	   set ruler
	" ---------------------------------------
	" Statusline Format
	" ---------------------------------------
	  set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%]\ (line:%l\/%L\ col:%v) 
	" ---------------------------------------
	" Gui Options 
	" ---------------------------------------
           if has('gui_running')
              " set transparency=4
	   	set columns=88 " inc. width of number/folding columns
           	set lines=48 " perfect size for me
	   	set mousehide " hide the mouse cursor when typing
		" To enable the saving and restoring of screen positions.
		let g:screen_size_restore_pos = 1

		" To save and restore screen for each Vim instance.
		" This is useful if you routinely run more than one Vim instance.
		" For all Vim to use the same settings, change this to 0.
		let g:screen_size_by_vim_instance = 1

            	set guioptions=ace
            		      " ||
			      " |`---------- use simple dialogs rather than pop-ups
            		      " |
			      " `----------- use GUI tabs, not console style tabs
            	set guioptions-=mTlLrR
            		      " ||||||
			      " |||||`----- remove righthand scrollbar
            		      " |||||
			      " ||||`------ ?
            		      " ||||
			      " |||`------- ?
            		      " |||
			      " ||`-------- ?
            		      " ||
			      " |`--------- remove toolbar
            		      " |
			      " `---------- remove gui menu
               		      "
	   endif
" ------------------------------------------------
" Text Formatting/Wrapping
" ------------------------------------------------
    " Wrap and Indent
    " --------------------------------------------
       set wrap
       set textwidth=79
       set autoindent
       set tabstop=4
       set expandtab
       set shiftwidth=4
       "set softtabstop=4

" ------------------------------------------------
" File Formats
" ------------------------------------------------
    " Indent
    " --------------------------------------------
    autocmd FileType ruby set tabstop=2|set shiftwidth=2

" ------------------------------------------------
"  Latex
" ------------------------------------------------
    map <silent>,l :! latexmk -pdfdvi % <CR><CR>
    map <silent>,la :! evince %<.pdf <CR><CR>
