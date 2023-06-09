defmodule Canary.Machines.Machine do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "machines" do
    field :ip_address, :string
    field :name, :string
    field :payload, :map
    field :online, :string
    field :notes, :string

    timestamps()
  end

  @doc false
  def changeset(machine, attrs) do
    machine
    |> cast(attrs, [:name, :ip_address, :payload, :online, :notes])
    |> validate_required([:name, :ip_address])
  end
end
