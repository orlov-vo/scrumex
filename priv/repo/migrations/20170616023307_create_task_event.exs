defmodule Scrumex.Repo.Migrations.CreateTaskEvent do
  use Ecto.Migration

  def change do
    create table(:task_events) do
      add :type, :integer, default: 0
      add :message, :text

      add :task_id, references(:tasks, on_delete: :delete_all), null: false
      add :author_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:task_events, [:task_id])
    create index(:task_events, [:author_id])
  end
end
