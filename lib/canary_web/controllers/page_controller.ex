defmodule CanaryWeb.PageController do
  use CanaryWeb, :controller

  alias Canary.Machines
  # alias Canary.Machines.Machine

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # Task.async(fn -> ping("192.168.10.66") end)
    # Task.async(fn -> ping("192.168.10.24") end)

    machines = Machines.list_machines()
    render(conn, :home, layout: false, machines: machines)
  end
end
