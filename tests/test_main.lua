local expect = MiniTest.expect
local child = MiniTest.new_child_neovim()

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      child.restart({ '-u', 'scripts/minimal_init.lua' })
      child.bo.readonly = false
      child.o.lines = 40
      child.o.columns = 160

      child.cmd [[ set rtp+=deps/plenary.nvim ]]
      child.cmd [[ set rtp+=deps/telescope.nvim ]]
      child.lua [[ M = require('telescope_quix') ]]

      child.lua [=[ function slurp_test_data(filename) 
          local result = vim.json.decode(vim.fn.join(vim.fn.readfile('tests/'..filename), '\n'))

          if vim.tbl_islist(result) then
            return result
          else
            return { result }
          end
      end ]=]

      child.lua [=[ M.quix = function(args) 
        if vim.deep_equal(args, { 'applications', 'list' }) then
          return slurp_test_data('quix_applications.json')
        elseif vim.deep_equal(args, { 'deployments', 'list' }) then
          return slurp_test_data('quix_deployments.json')
        elseif vim.deep_equal(args, { 'environments', 'list' }) then
          return slurp_test_data('quix_environments.json')
        elseif vim.deep_equal(args, { 'library', 'list' }) then
          return slurp_test_data('quix_library.json')
        elseif vim.deep_equal(args, { 'organisations', 'get' }) then
          return slurp_test_data('quix_organisations.json')
        elseif vim.deep_equal(args, { 'projects', 'list' }) then
          return slurp_test_data('quix_projects.json')
        elseif vim.deep_equal(args, { 'topics', 'list' }) then
          return slurp_test_data('quix_topics.json')
        elseif vim.deep_equal(args, { 'workspaces', 'list' }) then
          return slurp_test_data('quix_workspaces.json')
        else
          return {}
        end
      end ]=]
    end,
    post_once = child.stop,
  },
})

T.quix_applications = function()
  child.lua [[ M.quix_applications() ]]
  expect.reference_screenshot(child.get_screenshot())
end

T.quix_deployments = function()
  child.lua [[ M.quix_deployments() ]]
  expect.reference_screenshot(child.get_screenshot())
end

T.quix_environments = function()
  child.lua [[ M.quix_environments() ]]
  expect.reference_screenshot(child.get_screenshot())
end

T.quix_library = function()
  child.lua [[ M.quix_library() ]]
  expect.reference_screenshot(child.get_screenshot())
end

T.quix_organisations = function()
  child.lua [[ M.quix_organisations() ]]
  expect.reference_screenshot(child.get_screenshot())
end

T.quix_projects = function()
  child.lua [[ M.quix_projects() ]]
  expect.reference_screenshot(child.get_screenshot())
end

T.quix_topics = function()
  child.lua [[ M.quix_topics() ]]
  expect.reference_screenshot(child.get_screenshot())
end

T.quix_workspaces = function()
  child.lua [[ M.quix_workspaces() ]]
  expect.reference_screenshot(child.get_screenshot())
end

return T
