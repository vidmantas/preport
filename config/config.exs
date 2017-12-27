# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :preport,
  ecto_repos: [Preport.Repo]

# Configures the endpoint
config :preport, PreportWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hdoUHdV33o6fw8QNBSWJiJ8vHUbI18BMdKrC/NDjEBV8ElakrmShSqe8+GncPX5A",
  render_errors: [view: PreportWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Preport.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
import_config "#{Mix.env}.secret.exs"
