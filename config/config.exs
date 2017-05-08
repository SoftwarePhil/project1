# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :rent_me, RentMe.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "L39CmAeREPpJIA0j3uf67XbuN/irCuw+01AG/8CG7I2Op/M6Ra1ULRt2kZkZs/Mg",
  render_errors: [view: RentMe.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RentMe.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
