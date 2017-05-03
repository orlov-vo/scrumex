defmodule Scrumex.Plug.Auth do
  import Plug.Conn
  import Scrumex.Helper.CryptoCookie

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_encrypted_cookie(conn, "_scrumex_user")

    cond do
      user = conn.assigns[:current_user] ->
        assign(conn, :current_user, user)
      user = user_id && repo.get(Scrumex.User, user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end
end
