defmodule CanaryWeb.HomeLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  alias Canary.Machines

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-3">
      <%= for machine <- @machines do %>
        <div class="bg-white p-4 rounded opacity-75">
          <p>
            <.link navigate={"/machines/#{machine.id}"}><%= machine.name %></.link>
          </p>
          <p>
            <span class="text-gray-400"><%= machine.ip_address %></span>
            <%= if  machine.online == "initializing" do %>
              <span class="bg-gray-300 rounded-full h-3 w-3 inline-block"></span>
            <% end %>
            <%= if  machine.online == "online" do %>
              <span class="bg-green-500 rounded-full h-3 w-3 inline-block"></span>
            <% end %>
            <%= if  machine.online == "down" do %>
              <span class="bg-red-500 rounded-full h-3 w-3 inline-block"></span>
            <% end %>
          </p>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    # Initial update starts after 1 second
    if connected?(socket), do: Process.send_after(self(), :update, 1000)

    machines =
      Machines.list_machines()
      |> Enum.map(fn machine ->
        %{
          id: machine.id,
          name: machine.name,
          ip_address: machine.ip_address,
          online: "initializing"
        }
      end)

    {:ok, assign(socket, :machines, machines)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 60000)

    machines =
      Machines.list_machines()
      |> Enum.map(fn machine ->
        %{machine | online: ping(machine.ip_address)}
      end)

    {:noreply, assign(socket, :machines, machines)}
  end

  def ping(ip_address) do
    response = System.cmd("ping", ["-c", "1", ip_address])

    case response do
      {_output, 0} ->
        "online"

      {output, 1} ->
        IO.inspect(output)
        "down"
    end
  end
end
