# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :scrumex,
  ecto_repos: [Scrumex.Repo]

# Configures the endpoint
config :scrumex, Scrumex.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GMyAwKYXog/4lzumsTrjPkXv7ZrWRaN7yoE5kpQi6A2EFfvjGiiabaC+an7IhWE+",
  render_errors: [view: Scrumex.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Scrumex.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :cipher,
  keyphrase: "U8EdvGpdKx4namP&",
  ivphrase: "Mx9!LqNW^$=mY6Wd",
  magic_token: "magictoken"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
