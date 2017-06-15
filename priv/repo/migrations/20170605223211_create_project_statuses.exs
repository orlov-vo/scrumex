defmodule Scrumex.Repo.Migrations.CreateProjectStatuses do
  use Ecto.Migration

  def change do
    create table(:project_statuses) do
      add :name, :string, null: false
      add :position, :integer, default: 0

      add :project_id, references(:projects, on_delete: :delete_all), null: false
    end

    create index(:project_statuses, [:project_id])
  end
end
