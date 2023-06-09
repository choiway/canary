defmodule Canary.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Canary.InitMachineWatchers

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CanaryWeb.Telemetry,
      # Start the Ecto repository
      Canary.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Canary.PubSub},
      # Start Finch
      {Finch, name: Canary.Finch},
      # Start the Endpoint (http/https)
      {DynamicSupervisor, name: Canary.DynamicSupervisor, strategy: :one_for_one},
      CanaryWeb.Endpoint
      # Start a worker by calling: Canary.Worker.start_link(arg)
      # {Canary.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Canary.Supervisor]
    start_response = Supervisor.start_link(children, opts)

    case start_response do
      {:ok, _} ->
        InitMachineWatchers.init()
        start_response

      _ ->
        start_response
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CanaryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
