# Since configuration is shared in umbrella projects, this file
# should only configure the :microcosm application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :microcosm, Microcosm.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: 15
# username: "postgres",
# password: "postgres",
# database: "microcosm_prod",
