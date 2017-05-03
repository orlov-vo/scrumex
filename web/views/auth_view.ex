defmodule Scrumex.AuthView do
  use Scrumex.Web, :view

  alias Scrumex.User

  def auth_path(conn, user) do
    {:ok, encoded} = User.encoded_auth(user)
    sign_in_path(conn, :create, encoded)
  end

  def auth_url(conn, user) do
    {:ok, encoded} = User.encoded_auth(user)
    sign_in_url(conn, :create, encoded)
  end
end
