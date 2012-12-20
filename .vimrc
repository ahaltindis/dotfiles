" -------------------------------------------------
"   Ahmet A. <darchws@gmail.com>
"   http://darch.ws
"   vimrc
"   Last changed: 2012 Sep 05
" -------------------------------------------------
" Environment
" -------------------------------------------------
"	" Setup Bundle Support
"	" -----------------------------------------
"	   " Pathogen settings
	   call pathogen#runtime_append_all_bundles()
	   call pathogen#helptags()
	   filetype plugin indent on
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
	   	set columns=88 
           	set lines=48 
	   	set mousehide 
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
