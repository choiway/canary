defmodule Canary.Machines do
  @moduledoc """
  The Machines context.
  """

  import Ecto.Query, warn: false
  alias Canary.Repo

  alias Canary.Machines.Machine

  @doc """
  Returns the list of machines.

  ## Examples

      iex> list_machines()
      [%Machine{}, ...]

  """
  def list_machines do
    Repo.all(from m in Machine, order_by: [asc: m.id])
  end

  @doc """
  Gets a single machine.

  Raises `Ecto.NoResultsError` if the Machine does not exist.

  ## Examples

      iex> get_machine!(123)
      %Machine{}

      iex> get_machine!(456)
      ** (Ecto.NoResultsError)

  """
  def get_machine!(id), do: Repo.get!(Machine, id)

  @doc """
  Creates a machine.

  ## Examples

      iex> create_machine(%{field: value})
      {:ok, %Machine{}}

      iex> create_machine(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_machine(attrs \\ %{}) do
    %Machine{}
    |> Machine.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a machine.

  ## Examples

      iex> update_machine(machine, %{field: new_value})
      {:ok, %Machine{}}

      iex> update_machine(machine, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_machine(%Machine{} = machine, attrs) do
    machine
    |> Machine.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a machine.

  ## Examples

      iex> delete_machine(machine)
      {:ok, %Machine{}}

      iex> delete_machine(machine)
      {:error, %Ecto.Changeset{}}

  """
  def delete_machine(%Machine{} = machine) do
    Repo.delete(machine)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking machine changes.

  ## Examples

      iex> change_machine(machine)
      %Ecto.Changeset{data: %Machine{}}

  """
  def change_machine(%Machine{} = machine, attrs \\ %{}) do
    Machine.changeset(machine, attrs)
  end

  alias Canary.Machines.Ping

  def list_pings do
    Repo.all(from p in Ping, order_by: [asc: p.id])
  end

  def list_pings_for_machine(machine_id) do
    Repo.all(from p in Ping, where: p.machine_id == ^machine_id, order_by: [desc: p.inserted_at], limit: 30)
  end

  def create_ping(attrs \\ %{}) do
    %Ping{}
    |> Ping.changeset(attrs)
    |> Repo.insert()
  end

end
