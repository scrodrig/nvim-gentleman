-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Fallback: if user manually navigates to a diff window that still has no filetype,
-- copy it from the other diff panel and restart treesitter.
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if not vim.wo.diff then return end
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local diff_wins = vim.tbl_filter(function(w) return vim.api.nvim_win_get_option(w, "diff") end, wins)
    local ft_source = ""
    for _, win in ipairs(diff_wins) do
      local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
      if ft ~= "" then ft_source = ft; break end
    end
    if ft_source == "" then return end
    for _, win in ipairs(diff_wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "" then
        vim.bo[buf].filetype = ft_source
        pcall(vim.treesitter.start, buf)
      end
    end
  end,
})

