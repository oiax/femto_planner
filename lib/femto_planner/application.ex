defmodule FemtoPlanner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FemtoPlannerWeb.Telemetry,
      FemtoPlanner.Repo,
      {DNSCluster,
       query:
         Application.get_env(:femto_planner, :dns_cluster_query) ||
           :ignore},
      {Phoenix.PubSub, name: FemtoPlanner.PubSub},
      # Start a worker by calling: FemtoPlanner.Worker.start_link(arg)
      # {FemtoPlanner.Worker, arg},
      # Start to serve requests, typically the last entry
      FemtoPlannerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FemtoPlanner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FemtoPlannerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
