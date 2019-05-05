defmodule Microcosm.Repo do
  use Ecto.Repo,
    otp_app: :microcosm,
    adapter: Ecto.Adapters.Postgres
end
