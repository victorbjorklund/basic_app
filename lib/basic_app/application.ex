defmodule BasicApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BasicAppWeb.Telemetry,
      BasicApp.Repo,
      {DNSCluster, query: Application.get_env(:basic_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BasicApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BasicApp.Finch},
      # Start a worker by calling: BasicApp.Worker.start_link(arg)
      # {BasicApp.Worker, arg},
      # Start to serve requests, typically the last entry
      BasicAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BasicApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BasicAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
