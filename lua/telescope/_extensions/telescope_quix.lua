local telescope_quix = require('telescope_quix')

return require('telescope').register_extension({
  exports = {
    quix_applications = telescope_quix.quix_applications,
    quix_deployments = telescope_quix.quix_deployments,
    quix_environments = telescope_quix.quix_environments,
    quix_library = telescope_quix.quix_library,
    quix_organisations = telescope_quix.quix_organisations,
    quix_projects = telescope_quix.quix_projects,
    quix_repositories = telescope_quix.quix_repositories,
    quix_topics = telescope_quix.quix_topics,
    quix_workspaces = telescope_quix.quix_workspaces,
  },
})
