defmodule Scrumex.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :slug, :string

      add :owner_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:projects, [:owner_id])
  end
end
