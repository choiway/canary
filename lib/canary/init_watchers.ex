defmodule Canary.InitMachineWatchers do
  alias Canary.Machines

  def init() do
    machines = Machines.list_machines()

    machines
    |> Enum.map(fn machine ->
      Task.start(fn -> start_trader(machine) end)
    end)
  end

  def start_trader(%Machines.Machine{} = machine) do
    # In order to distribute the load, we start each trader with a randome delay
    # This function should be started asyncronously or the dealy will kill start up times
    # since this runs before the endpoint is initialized
    random_delay = 0..20 |> Enum.random()

    IO.puts("Starting Watcher for Machine #{machine.id} with a #{random_delay} second delay")

    Process.sleep(random_delay * 1000)

    DynamicSupervisor.start_child(
      Canary.DynamicSupervisor,
      {Canary.MachineWatcher, [machine: machine]}
    )
  end
end
