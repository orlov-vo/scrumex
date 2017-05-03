defmodule Scrumex.Repo.Migrations.AddAuthTokenForUserModel do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :auth_token, :string
      add :auth_token_expires_at, :naive_datetime
    end
  end
end
