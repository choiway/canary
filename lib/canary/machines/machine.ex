defmodule Canary.Machines.Machine do
  use Ecto.Schema
  import Ecto.Changeset

  schema "machines" do
    field :ip_address, :string
    field :name, :string
    field :payload, :map

    timestamps()
  end

  @doc false
  def changeset(machine, attrs) do
    machine
    |> cast(attrs, [:name, :ip_address, :payload])
    |> validate_required([:name, :ip_address])
  end
end
