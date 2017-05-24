defmodule Scrumex.Plug.RequireGuest do
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
      |> put_flash(:success, "Вы уже зашли!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
