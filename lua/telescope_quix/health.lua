local health = vim.health or require 'health'

local M = {}

M.check = function()
  health.start 'Checking...'
  if vim.fn.executable('quix') == 1 then
    health.ok('quix binary installed.')
  else
    health.error('quix binary not fund.')
  end
end

return M
