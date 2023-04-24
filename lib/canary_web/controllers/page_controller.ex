defmodule CanaryWeb.PageController do
  use CanaryWeb, :controller

  alias Canary.Machines
  # alias Canary.Machines.Machine

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    Task.async(fn -> ping("192.168.10.66") end)
    Task.async(fn -> ping("192.168.10.24") end)

    machines = Machines.list_machines()
    render(conn, :home, layout: false, machines: machines)
  end

  def ping(ip_address) do
    response = System.cmd("ping", ["-c", "1", ip_address])

    case response do
      {output, 0} ->
        [_ping_message, icmp_response, _, _ping_statistics, packets_trasmitted, _rtt_msg, _] =
          String.split(output, "\n")

        IO.puts(icmp_response)
        IO.puts(packets_trasmitted)

        IO.puts("Machine at #{ip_address} is up")

      # Machines.update_machine(%{ip_address: ip_address, payload: %{status: "up"}})
      {output, 1} ->
        [_ping_message, icmp_response, _, _ping_statistics, packets_trasmitted, _rtt_msg, _] =
          String.split(output, "\n")

        IO.puts(icmp_response)
        IO.puts(packets_trasmitted)

        IO.puts("Machine at #{ip_address} is down")

        # Machines.update_machine(%{ip_address: ip_address, payload: %{status: "down"}})
    end
  end
end
