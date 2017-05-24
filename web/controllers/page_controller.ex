defmodule Scrumex.PageController do
  use Scrumex.Web, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: page_path(conn, :home))
    else
      redirect(conn, to: sign_in_path(conn, :new))
    end
  end

  def home(conn, _params) do
    render(conn, "home.html")
  end
end
