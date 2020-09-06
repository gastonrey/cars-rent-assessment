# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cars_app,
  ecto_repos: [CarsApp.Repo],
  generators: [binary_id: true]

# Add support for microseconds at the database level
# avoid having to configure it on every migration file
config :cars_app, CarsApp.Repo, migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :cars_app, CarsAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QUgIt9EFkjSdUeiMe0hf1Yw5NHrFPiqdeUGkCJxXg8fvj3SFA7i0U+b2czkUJRRD",
  render_errors: [view: CarsAppWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: CarsApp.PubSub,
  live_view: [signing_salt: "atzeUu1N"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
