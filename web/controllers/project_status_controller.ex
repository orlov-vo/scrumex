defmodule Scrumex.Project.StatusController do
  use Scrumex.Web, :controller

  alias Scrumex.{Project, ProjectStatus, Task, User}

  def create(conn, %{"project_id" => slug_id, "project_status" => status_params}) do
    project = Project.get_from_slug_id(slug_id)
    changeset = ProjectStatus.changeset(%ProjectStatus{}, status_params)

    case Repo.insert(changeset) do
      {:ok, _status} ->
        conn
        |> put_flash(:info, "Status created successfully.")
        |> redirect(to: project_path(conn, :show, project))
      {:error, changeset} ->
        render(conn, "new.html", project: project, changeset: changeset)
    end
  end
end
