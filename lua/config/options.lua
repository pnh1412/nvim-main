-- NOTE: Neovim options

local options = {
  laststatus = 3, -- global statusline
  backup = false, -- creates a backup file
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  hidden = true, -- required to keep multiple buffers and open multiple buffers
  ignorecase = true, -- ignore case in search patterns
  mouse = "a", -- allow the mouse to be used in neovim
  pumheight = 10, -- pop up menu height
  pumblend = 0, -- transparency of pop-up menu
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  splitkeep = "screen", -- don't automatically close empty splits
  swapfile = true, -- creates a swapfile
  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 200, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  tabstop = 2, -- insert 2 spaces for a tab
  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 5, -- set number column width to 4 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  scrolloff = 8, -- minimal number of lines to keep above and below cursor
  sidescrolloff = 8, -- minimal number of columns to scroll horizontally
  lazyredraw = false, -- Won't be redrawn while executing macros, register and other commands.
  termguicolors = true, -- Enables 24-bit RGB color in the TUI
  fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "", lastline = " " }, -- make EndOfBuffer invisible
  ruler = true, -- show the line and column number of the cursor position
  cmdheight = 1, -- height of the command line
  helpheight = 10, -- height of the help window
  sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",
  completeopt = "menu,menuone,noinsert", -- completion options
  wildmode = "longest:full,full", -- command-line completion mode
  wildmenu = true, -- enable wildmenu
  list = false, -- show some special characters
}

vim.opt.shortmess:append "Ac" -- Disable asking

for name, value in pairs(options) do
  vim.opt[name] = value
end
