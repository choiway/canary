defmodule CanaryWeb.MachineComponent do
  use Phoenix.LiveComponent

  @topic "machines"

  def render(assigns) do
    ~H"""
    <div>
      <div>
        <%= for {ping, i} <- @pings |> Enum.with_index do %>
          <%= if  ping.status == "online" do %>
            <%= if i == 0 do %>
              <span class="bg-green-400 rounded h-5 w-1 inline-block"></span>
            <% else %>
              <span class="bg-green-400 opacity-50 rounded h-5 w-1 inline-block"></span>
            <% end %>
          <% end %>
          <%= if  ping.status == "down" do %>
            <%= if i == 0 do %>
              <span class="bg-red-400 rounded h-5 w-1 inline-block"></span>
            <% else %>
              <span class="bg-red-400 opacity-70 rounded h-5 w-1 inline-block"></span>
            <% end %>
          <% end %>
        <% end %>
      </div>
      <div class="text-gray-500 text-sm">
        <span class="machine-ts" mod-highlight={@machine_id == @machine.id}>
          <%= @pings |> get_timestamp_from_last_ping %>
        </span>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    # IO.inspect(assigns)
    {:ok, assign(socket, assigns)}
  end

  defp get_timestamp_from_last_ping(pings) when is_list(pings) do
    last_ping = pings |> List.first()

    case last_ping do
      nil ->
        ""

      _ ->
        Map.get(last_ping, :updated_at)
    end
  end
end
