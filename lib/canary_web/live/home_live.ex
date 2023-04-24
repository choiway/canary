defmodule CanaryWeb.HomeLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  alias Canary.Machines

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-3">
      <%= for machine <- @machines do %>
        <div class="bg-white p-4 rounded opacity-75">
          <p><%= machine.name %></p>
          <p><%= machine.ip_address %></p>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 30000)


    machines = Machines.list_machines()
    {:ok, assign(socket, :machines, machines)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 30000)
    IO.puts("Updating the machines")

    machines = Machines.list_machines()
    {:noreply, assign(socket, :machines, machines)}
  end
end
