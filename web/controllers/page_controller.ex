defmodule Scrumex.PageController do
  use Scrumex.Web, :controller

  alias Scrumex.{Repo, User, Project}

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: page_path(conn, :home))
    else
      redirect(conn, to: sign_in_path(conn, :new))
    end
  end

  def home(conn, _params) do
    projects = conn
    |> User.get_current()
    |> assoc(:owned_projects)
    |> Project.preload_all()
    |> Repo.all()

    conn
    |> put_flash(:info, "test 1")
    |> put_flash(:info, "test 2")
    |> render("home.html",
      favourite_projects: projects,
      layout: {Scrumex.LayoutView, "dark.html"})
  end
end
