defmodule Canary.MachinesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Canary.Machines` context.
  """

  @doc """
  Generate a machine.
  """
  def machine_fixture(attrs \\ %{}) do
    {:ok, machine} =
      attrs
      |> Enum.into(%{
        ip_address: "some ip_address",
        name: "some name",
        payload: %{}
      })
      |> Canary.Machines.create_machine()

    machine
  end
end
