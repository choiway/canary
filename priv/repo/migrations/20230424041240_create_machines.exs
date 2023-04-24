defmodule Canary.Repo.Migrations.CreateMachines do
  use Ecto.Migration

  def change do
    create table(:machines) do
      add :name, :string
      add :ip_address, :string
      add :payload, :map

      timestamps()
    end
  end
end
