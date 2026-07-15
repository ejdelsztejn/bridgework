defmodule Bridgework.Repo do
  use Ecto.Repo,
    otp_app: :bridgework,
    adapter: Ecto.Adapters.Postgres
end
