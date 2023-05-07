defmodule Canary.Repo.Migrations.CreatePings do
  use Ecto.Migration

  def change do
    create table(:pings) do
      add :machine_id, :id
      add :type, :string
      add :status, :string

      timestamps()
    end
  end
end
