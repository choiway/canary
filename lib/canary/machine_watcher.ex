defmodule Canary.MachineWatcher do
  use GenServer
  require Logger
  alias Canary.Machines
  alias Canary.Machines.Machine

  @moduledoc """
  The Machine Watcher process.
  Document the state variables here
  """

  @topic "machines"

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(state \\ [machine: %Machine{}]) do
    machine_id = state[:machine].id

    IO.puts("Starting Watcher for Machine #{machine_id}")

    GenServer.start_link(__MODULE__, state, name: String.to_atom("watcher_#{machine_id}"))
  end

  @impl true
  def init(state) do
    # Logger.info("Initializing a trader with the following state")
    # IO.inspect(state)
    pings = Machines.list_pings_for_machine(state[:machine].id)

    CanaryWeb.Endpoint.broadcast_from(
      self(),
      @topic,
      "update",
      %{machine: state[:machine], pings: pings}
    )

    schedule_work()
    {:ok, [machine: state[:machine], pings: pings]}
  end

  @impl true
  def handle_call(:pop_pings, _from, state = [machine: %Machine{} = _machine, pings: pings]) do
    {:reply, pings, state}
  end

  @impl true
  def handle_info(:work, _state = [machine: %Machine{} = machine, pings: pings]) do
    # IO.puts("Working. State is:")
    # IO.inspect(state)
    online_status = ping(machine.ip_address)

    new_ping = %{
      machine_id: machine.id,
      type: "ping",
      status: online_status
    }

    updated_pings = [new_ping | pings] |> Enum.take(30)

    # IO.puts("Machine #{machine.id} is #{online_status}")
    # update_response = Machines.update_machine(machine, %{online: online_status})
    create_response = Machines.create_ping(new_ping)
    # IO.inspect(create_response)

    case create_response do
      {:ok, _new_ping} ->
        CanaryWeb.Endpoint.broadcast_from(
          self(),
          @topic,
          "update",
          %{machine: machine, pings: updated_pings}
        )

      {:error, changeset} ->
        IO.puts("The following error(s) occurred while trying to update machine")
        IO.inspect(changeset)
    end

    schedule_work()

    {:noreply, [machine: machine, pings: updated_pings]}
  end

  defp schedule_work() do
    seconds = 60
    Process.send_after(self(), :work, seconds * 1000)
  end

  def ping(ip_address) do
    response = System.cmd("ping", ["-c", "1", ip_address])

    case response do
      {_output, 0} ->
        "online"

      {_output, 1} ->
        # IO.inspect(output)
        "down"

      {output, 2} ->
        IO.inspect(output, label: "Ping response with error code: 2")
        "down"
    end
  end
end
