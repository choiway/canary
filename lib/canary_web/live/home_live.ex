defmodule CanaryWeb.HomeLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  alias Canary.Machines

  @topic "machines"

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-3">
      <%= for machine <- @machines do %>
        <div class="border border-gray-600 p-4 rounded">
          <p>
            <.link class="text-white" navigate={"/machines/#{machine.id}"}><%= machine.name %></.link>
          </p>
          <p>
            <span class="text-gray-400 text-sm"><%= machine.ip_address %></span>
          </p>
          <div>
            <%= if Enum.empty?(Map.get(@pings_map, machine.id)) do %>
              <span class="text-gray-400">Loading...</span>
            <% else %>
              <.live_component
                module={CanaryWeb.MachineComponent}
                id={machine.id}
                machine={machine}
                machine_id={@machine_id}
                pings={Map.get(@pings_map, machine.id)}
              />
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    CanaryWeb.Endpoint.subscribe(@topic)

    machines = Machines.list_machines()
    pings_map = init_pings(machines)

    {:ok, assign(socket, machines: machines, pings_map: pings_map, machine_id: nil)}
  end

  # pings map is a map of machine_id => [pings]
  #  Initializes with empty list of pings for each machine
  defp init_pings(machines) do
    machines
    |> Map.new(fn m ->
      {m.id, get_pings(m.id)}
    end)
  end

  def get_pings(machine_id) do
    machine_id_atom = String.to_atom("watcher_#{machine_id}")

    case Process.whereis(machine_id_atom) do
      nil ->
        []

      pid when is_pid(pid) ->
        GenServer.call(machine_id_atom, :pop_pings)
    end
  end

  def handle_info(
        %{topic: @topic, event: "update", payload: %{machine: machine, pings: pings}},
        socket
      ) do
    pings_map = socket.assigns.pings_map
    updated_pings = pings_map |> Map.put(machine.id, pings)

    {:noreply, assign(socket, pings_map: updated_pings, machine_id: machine.id)}
  end
end
