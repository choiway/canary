defmodule CanaryWeb.MachineController do
  use CanaryWeb, :controller

  alias Canary.Machines
  alias Canary.Machines.Machine

  def index(conn, _params) do
    machines = Machines.list_machines()
    render(conn, :index, machines: machines)
  end

  def new(conn, _params) do
    changeset = Machines.change_machine(%Machine{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"machine" => machine_params}) do
    case Machines.create_machine(machine_params) do
      {:ok, machine} ->
        conn
        |> put_flash(:info, "Machine created successfully.")
        |> redirect(to: ~p"/machines/#{machine}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    machine = Machines.get_machine!(id)
    render(conn, :show, machine: machine)
  end

  def edit(conn, %{"id" => id}) do
    machine = Machines.get_machine!(id)
    changeset = Machines.change_machine(machine)
    render(conn, :edit, machine: machine, changeset: changeset)
  end

  def update(conn, %{"id" => id, "machine" => machine_params}) do
    machine = Machines.get_machine!(id)

    case Machines.update_machine(machine, machine_params) do
      {:ok, machine} ->
        conn
        |> put_flash(:info, "Machine updated successfully.")
        |> redirect(to: ~p"/machines/#{machine}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, machine: machine, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    machine = Machines.get_machine!(id)
    {:ok, _machine} = Machines.delete_machine(machine)

    conn
    |> put_flash(:info, "Machine deleted successfully.")
    |> redirect(to: ~p"/machines")
  end
end
