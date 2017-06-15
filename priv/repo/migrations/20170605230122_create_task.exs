defmodule Scrumex.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :description, :text
      add :position, :integer, default: 0

      add :status_id, references(:project_statuses, on_delete: :delete_all), null: false
      add :priority_id, :integer, null: false

      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :author_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:tasks, [:project_id])
    create index(:tasks, [:author_id])
  end
end
