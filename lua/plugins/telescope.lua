return {
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    -- 0.1.8 uses vim.treesitter.language.ft_to_lang, which was removed in
    -- Neovim 0.12. Use the current branch for Neovim's current API.
    'nvim-telescope/telescope.nvim', branch = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup{
        defaults = {
          path_display={"smart"} 
        }
      }
      local builtin = require('telescope.builtin')
      local function project_cwd()
        local oil_ok, oil = pcall(require, 'oil')
        local dir = oil_ok and oil.get_current_dir(0) or nil

        if not dir then
          local buffer = vim.api.nvim_buf_get_name(0)
          if buffer ~= '' and not buffer:match('^%w+://') then
            dir = vim.fs.dirname(vim.fs.normalize(buffer))
          end
        end

        dir = dir or vim.loop.cwd()
        return vim.fs.root(dir, { '.git' }) or dir
      end

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>ft', builtin.git_files, { desc = 'Telescope find git files' })
      vim.keymap.set('n', '<leader>fg', function()
        builtin.live_grep({ cwd = project_cwd() })
      end, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") });
      end)
    end,
  }
}
