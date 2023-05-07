defmodule CanaryWeb.HomeLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  alias Canary.Machines

  @topic "machines"

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-3">
      <%= for machine <- @machines do %>
        <div class="bg-white p-4 rounded opacity-75">
          <p>
            <.link navigate={"/machines/#{machine.id}"}><%= machine.name %></.link>
          </p>
          <p>
            <span class="text-gray-400 text-sm"><%= machine.ip_address %></span>
          </p>
          <div>
            <%= for ping <- Map.get(@pings_map, machine.id) do %>
              <%= if  ping.status == "online" do %>
                <span class="bg-green-300 rounded h-5 w-1 inline-block"></span>
              <% end %>
              <%= if  ping.status == "down" do %>
                <span class="bg-red-300 rounded h-5 w-1 inline-block"></span>
              <% end %>
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
    # IO.inspect(pings)

    {:ok, assign(socket, machines: machines, pings_map: pings_map)}
  end

  # pings map is a map of machine_id => [pings]
  #  Initializes with empty list of pings for each machine
  defp init_pings(machines) do
    machines
    |> Map.new(fn m ->
      {m.id, []}
    end)
  end

  def handle_info(
        %{topic: @topic, event: "update", payload: %{machine: machine, pings: pings}},
        socket
      ) do
    # IO.puts("HANDLE BROADCAST FOR:")
    # IO.inspect(machine)
    pings_map = socket.assigns.pings_map
    updated_pings = pings_map |> Map.put(machine.id, pings)

    {:noreply, assign(socket, pings_map: updated_pings)}
  end
end
