# Since configuration is shared in umbrella projects, this file
# should only configure the :microcosm application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :microcosm,
  ecto_repos: [Microcosm.Repo]

import_config "#{Mix.env()}.exs"
