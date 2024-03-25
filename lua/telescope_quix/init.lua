local conf = require('telescope.config').values
local pickers = require('telescope.pickers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local tlog = require('telescope.log')
tlog.level = 'info'
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local utils = require('telescope.previewers.utils')
local plenary = require('plenary')
local log = require('plenary.log').new {
  plugin = 'telescope_quix',
  level = 'info',
}

local generic_define_preview = function(self, entry)
  local formatted = vim.tbl_flatten {
    '```lua',
    vim.split(vim.inspect(entry.value), '\n'),
    '```',
  }
  vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, formatted)

  utils.highlighter(self.state.bufnr, 'markdown')
end

---@class TQModule
---@field config TQConfig
---@field setup fun(TQConfig): TQModule

---@class TQConfig
---@field quix_path string | nil

local M = {}

---@param args string[]
---@return table[] | nil
M.quix = function(args)
  table.insert(args, '--output')
  table.insert(args, 'json')
  local job_opts = {
    command = M.config.quix_path or 'quix',
    args = args,
  }
  log.info('Running job', job_opts)
  local job = plenary.job:new(job_opts):sync()
  log.debug('Ran job', vim.fn.join(job, ' '))
  local result = vim.json.decode(vim.fn.join(job, ' '))
  if result == nil then
    return {}
  elseif vim.tbl_islist(result) then
    return result
  else
    return { result }
  end
end

M.quix_workspaces = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        fn = function()
          return M.quix({ 'workspaces', 'list' })
        end,

        entry_maker = function(entry)
          log.debug('Got raw entry', entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      previewer = previewers.new_buffer_previewer({
        title = 'Workspace Details',
        define_preview = function(self, entry)
          local formatted = vim.tbl_flatten {
            '# Name: ' .. entry.value.name,
            '',
            'workspaceId: ' .. entry.value.workspaceId,
            'status: ' .. entry.value.status,
            'repositoryId: ' .. entry.value.repositoryId,
            'branch: ' .. entry.value.branch,
            'environmentName: ' .. entry.value.environmentName,
            'version: ' .. vim.inspect(entry.value.version),
            '',
            'address: ' .. entry.value.broker.address,
            'username: ' .. entry.value.broker.username,
            'password: ' .. (entry.value.broker.password == '' and '' or '****'),
            'hasCertificate: ' .. vim.inspect(entry.value.broker.hasCertificate),
            'securityMode: ' .. entry.value.broker.securityMode,
            'sslPassword: ' .. (entry.value.broker.sslPassword == '' and '' or '****'),
            'saslMechanism: ' .. entry.value.broker.saslMechanism,
            '',
            'workspaceClassId: ' .. entry.value.workspaceClassId,
            'storageClassId: ' .. entry.value.storageClassId,
            'createdAt: ' .. entry.value.createdAt,
            '',
            'brokerSettings: ',
            '```lua',
            vim.split(vim.inspect(entry.value.brokerSettings), '\n'),
            '```',
          }

          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, formatted)

          utils.highlighter(self.state.bufnr, 'markdown')
        end,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.quix_applications = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        fn = function()
          return M.quix({ 'applications', 'list' })
        end,

        entry_maker = function(entry)
          log.debug('Got raw entry', entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      previewer = previewers.new_buffer_previewer({
        title = 'Application Details',
        define_preview = generic_define_preview,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.quix_library = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        fn = function()
          return M.quix({ 'library', 'list' })
        end,

        entry_maker = function(entry)
          log.debug('Got raw entry', entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      previewer = previewers.new_buffer_previewer({
        title = 'Library Details',
        define_preview = function(self, entry)
          local formatted = vim.tbl_flatten {
            '# ' .. entry.value.name,
            '',
            'Description: ' .. entry.value.shortDescription,
            '',
            'Language: ' .. entry.value.language,
            'Tags: ' .. vim.fn.join(entry.value.tags, ', '),
            '',
            '```lua',
            vim.split(vim.inspect(entry.value), '\n'),
            '```',
          }
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, false, formatted)
          vim.api.nvim_win_set_option(self.state.winid, 'wrap', true)

          utils.highlighter(self.state.bufnr, 'markdown')
        end,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.quix_environments = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        fn = function()
          return M.quix({ 'environments', 'list' })
        end,

        entry_maker = function(entry)
          log.debug('Got raw entry', entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      previewer = previewers.new_buffer_previewer({
        title = 'Environment Details',
        define_preview = function(self, entry)
          local formatted = vim.tbl_flatten {
            '# Name: ' .. entry.value.name,
            '',
            'workspaceId: ' .. entry.value.workspaceId,
            'status: ' .. entry.value.status,
            'repositoryId: ' .. entry.value.repositoryId,
            'branch: ' .. entry.value.branch,
            'environmentName: ' .. entry.value.environmentName,
            'version: ' .. vim.inspect(entry.value.version),
            '',
            'address: ' .. entry.value.broker.address,
            'username: ' .. entry.value.broker.username,
            'password: ' .. (entry.value.broker.password == '' and '' or '****'),
            'hasCertificate: ' .. vim.inspect(entry.value.broker.hasCertificate),
            'securityMode: ' .. entry.value.broker.securityMode,
            'sslPassword: ' .. (entry.value.broker.sslPassword == '' and '' or '****'),
            'saslMechanism: ' .. entry.value.broker.saslMechanism,
            '',
            'workspaceClassId: ' .. entry.value.workspaceClassId,
            'storageClassId: ' .. entry.value.storageClassId,
            'createdAt: ' .. entry.value.createdAt,
            '',
            'brokerSettings: ',
            '```lua',
            vim.split(vim.inspect(entry.value.brokerSettings), '\n'),
            '```',
          }

          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, formatted)

          utils.highlighter(self.state.bufnr, 'markdown')
        end,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.quix_organisations = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        fn = function()
          return M.quix({ 'organisations', 'get' })
        end,

        entry_maker = function(entry)
          log.debug('Got raw entry', entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      previewer = previewers.new_buffer_previewer({
        title = 'Organisation Details',
        define_preview = generic_define_preview,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.quix_projects = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        fn = function()
          return M.quix({ 'projects', 'list' })
        end,

        entry_maker = function(entry)
          log.debug('Got raw entry', entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      previewer = previewers.new_buffer_previewer({
        title = 'Project Details',
        define_preview = generic_define_preview,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.quix_repositories = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        fn = function()
          return M.quix({ 'repositories', 'list' })
        end,

        entry_maker = function(entry)
          log.debug('Got raw entry', entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      previewer = previewers.new_buffer_previewer({
        title = 'Repository Details',
        define_preview = generic_define_preview,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.quix_deployments = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        fn = function()
          return M.quix({ 'deployments', 'list' })
        end,

        entry_maker = function(entry)
          log.debug('Got raw entry', entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      previewer = previewers.new_buffer_previewer({
        title = 'Deployment Details',
        define_preview = generic_define_preview,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.quix_topics = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        fn = function()
          return M.quix({ 'topics', 'list' })
        end,

        entry_maker = function(entry)
          log.debug('Got raw entry', entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      previewer = previewers.new_buffer_previewer({
        title = 'Topic Details',
        define_preview = generic_define_preview,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

---@param config TQConfig
M.setup = function(config)
  M.config = config
end

return M
