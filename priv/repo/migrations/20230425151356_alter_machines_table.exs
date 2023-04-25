defmodule Canary.Repo.Migrations.AlterMachinesTable do
  use Ecto.Migration

  def change do
    alter table(:machines) do
      add :online, :text, default: "initializing"
      add :notes, :text
    end
  end
end
