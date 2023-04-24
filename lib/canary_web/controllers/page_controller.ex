defmodule CanaryWeb.PageController do
  use CanaryWeb, :controller

  alias Canary.Machines
  # alias Canary.Machines.Machine

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    machines = Machines.list_machines()
    render(conn, :home, layout: false, machines: machines)
  end
end
