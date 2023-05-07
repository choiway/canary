defmodule Canary.Machines.Ping do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "pings" do
    field :machine_id, :id
    field :type, :string
    field :status, :string

    timestamps()
  end

  def changeset(ping, attrs) do
    ping
    |> cast(attrs, [:type, :status, :machine_id])
    |> validate_required([:machine_id, :type, :status])
  end
end
