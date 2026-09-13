local opt = vim.opt
local o = vim.o

vim.cmd.colorscheme "tokyonight"

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
})

opt.relativenumber = true
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.scrolloff = 18
opt.wrap = true

o.swapfile = false
o.ignorecase = true
o.hidden = true
o.lazyredraw = true

opt.clipboard:append("unnamedplus") -- use system clipboard

if vim.env.TMUX and vim.fn.executable("tmux") == 1 then
  -- tmux must query the outer terminal itself; OSC 52 paste replies are not
  -- forwarded to applications running inside tmux.
  local copy = { "tmux", "load-buffer", "-w", "-" }
  local paste = {
    "sh",
    "-c",
    "tmux refresh-client -l && sleep 0.05 && tmux save-buffer -",
  }

  vim.g.clipboard = {
    name = "tmux",
    copy = {
      ["+"] = copy,
      ["*"] = copy,
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
    cache_enabled = 0,
  }
-- Outside tmux, use OSC 52 when no native clipboard helper is available.
elseif vim.fn.executable("pbcopy") == 0
    and vim.fn.executable("xclip") == 0
    and vim.fn.executable("wl-copy") == 0 then
  local osc52 = require("vim.ui.clipboard.osc52")

  vim.g.clipboard = {
    name = "OSC-52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
