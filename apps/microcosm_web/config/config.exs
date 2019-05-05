# Since configuration is shared in umbrella projects, this file
# should only configure the :microcosm_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :microcosm_web,
  ecto_repos: [Microcosm.Repo],
  generators: [context_app: :microcosm]

# Configures the endpoint
config :microcosm_web, MicrocosmWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yEGIpuJQvphxIsUwah1vhVs5JC1USSJHqQztGT++xvdMeT2/zH/aBv6XiKPyA4MM",
  render_errors: [view: MicrocosmWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MicrocosmWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
