defmodule Canary.MachinesTest do
  use Canary.DataCase

  alias Canary.Machines

  describe "machines" do
    alias Canary.Machines.Machine

    import Canary.MachinesFixtures

    @invalid_attrs %{ip_address: nil, name: nil, payload: nil}

    test "list_machines/0 returns all machines" do
      machine = machine_fixture()
      assert Machines.list_machines() == [machine]
    end

    test "get_machine!/1 returns the machine with given id" do
      machine = machine_fixture()
      assert Machines.get_machine!(machine.id) == machine
    end

    test "create_machine/1 with valid data creates a machine" do
      valid_attrs = %{ip_address: "some ip_address", name: "some name", payload: %{}}

      assert {:ok, %Machine{} = machine} = Machines.create_machine(valid_attrs)
      assert machine.ip_address == "some ip_address"
      assert machine.name == "some name"
      assert machine.payload == %{}
    end

    test "create_machine/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Machines.create_machine(@invalid_attrs)
    end

    test "update_machine/2 with valid data updates the machine" do
      machine = machine_fixture()
      update_attrs = %{ip_address: "some updated ip_address", name: "some updated name", payload: %{}}

      assert {:ok, %Machine{} = machine} = Machines.update_machine(machine, update_attrs)
      assert machine.ip_address == "some updated ip_address"
      assert machine.name == "some updated name"
      assert machine.payload == %{}
    end

    test "update_machine/2 with invalid data returns error changeset" do
      machine = machine_fixture()
      assert {:error, %Ecto.Changeset{}} = Machines.update_machine(machine, @invalid_attrs)
      assert machine == Machines.get_machine!(machine.id)
    end

    test "delete_machine/1 deletes the machine" do
      machine = machine_fixture()
      assert {:ok, %Machine{}} = Machines.delete_machine(machine)
      assert_raise Ecto.NoResultsError, fn -> Machines.get_machine!(machine.id) end
    end

    test "change_machine/1 returns a machine changeset" do
      machine = machine_fixture()
      assert %Ecto.Changeset{} = Machines.change_machine(machine)
    end
  end
end
