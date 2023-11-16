local opts = {
  noremap = true,
  silent = true,
}

vim.keymap.set('n', '<leader>w', ":w<cr>", opts)
vim.keymap.set('n', '<leader>q', ":quit<cr>", opts)

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Window resizing
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Naviagate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")        -- move line up(n)
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")        -- move line down(n)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")    -- move line up(v)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")    -- move line down(v)

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>") -- move line down(v)
