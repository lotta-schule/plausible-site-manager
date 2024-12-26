defmodule PlausibleSiteManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlausibleSiteManagerWeb.Telemetry,
      {PlausibleSiteManager.DB, Application.get_env(:plausible_site_manager, :repo_opts)},
      {DNSCluster,
       query: Application.get_env(:plausible_site_manager, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PlausibleSiteManager.PubSub},
      # Start a worker by calling: PlausibleSiteManager.Worker.start_link(arg)
      # {PlausibleSiteManager.Worker, arg},
      # Start to serve requests, typically the last entry
      PlausibleSiteManagerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlausibleSiteManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlausibleSiteManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
