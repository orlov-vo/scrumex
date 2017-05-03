defmodule Scrumex.Plug.RequireUser do
  import Plug.Conn
  import Phoenix.Controller
  import Scrumex.Router.Helpers

  require Logger

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:success, "Необходимо войти в систему!")
      |> redirect(to: page_path(conn, :home))
      |> halt()
    end
  end
end
