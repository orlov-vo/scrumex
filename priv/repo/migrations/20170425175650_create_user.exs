defmodule Scrumex.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :encrypted_password, :string, null: false

      add :admin, :boolean, default: false

      add :joined_at, :datetime
      add :signed_in_at, :datetime

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
