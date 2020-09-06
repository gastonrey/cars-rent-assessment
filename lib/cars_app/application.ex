defmodule CarsApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CarsApp.Repo,
      # Start the Telemetry supervisor
      CarsAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CarsApp.PubSub},
      # Start the Endpoint (http/https)
      CarsAppWeb.Endpoint
      # Start a worker by calling: CarsApp.Worker.start_link(arg)
      # {CarsApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CarsApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CarsAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
