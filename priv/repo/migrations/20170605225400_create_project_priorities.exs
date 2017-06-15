defmodule Scrumex.Repo.Migrations.CreateProjectPriorities do
  use Ecto.Migration

  def change do
    create table(:project_priorities) do
      add :name, :string, null: false
      add :position, :integer, default: 0

      add :project_id, references(:projects, on_delete: :delete_all), null: false
    end

    create index(:project_priorities, [:project_id])
  end
end
