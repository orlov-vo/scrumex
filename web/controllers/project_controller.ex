defmodule Scrumex.ProjectController do
  use Scrumex.Web, :controller

  require Logger

  alias Scrumex.{Repo, Project, User}

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    owned_projects = current_user
    |> assoc(:owned_projects)
    |> Project.preload_all()
    |> Repo.all()

    render(conn, "index.html", owned_projects: owned_projects)
  end

  def new(conn, _params) do
    project = %Project{}

    render(conn, "new.html", changeset: Project.changeset(project))
  end

  def create(conn, %{"project" => project_params}) do
    current_user = conn.assigns[:current_user]

    changeset = current_user
    |> build_assoc(:owned_projects)
    |> Project.changeset(project_params)

    Logger.debug "Create project: #{inspect(changeset)}"

    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, _project} ->
          conn
          |> put_status(:created)
          |> put_flash(:success, "Проект успешно создан")
          |> redirect(to: project_path(conn, :index))
        {:error, changeset} ->
          conn
          |> put_flash(:error, "Что-то пошло не так. 😭 #{current_user.id}")
          |> render("new.html", changeset: changeset)
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug_id}) do
    {project_id, slug} = Project.parse_slug_id(slug_id)
    project = Repo.get(Project, project_id)

    render(conn, "show.html", project: project)
  end

  def edit(conn, %{"id" => project_id}) do
    project = Repo.get!(Project, project_id)

    render(conn, "edit.html", changeset: Project.changeset(project), project: project)
  end

  def update(conn, %{"id" => project_id, "project" => project_params}) do
    project = Repo.get!(Project, project_id)
    changeset = Project.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Проект успешно обновлен.")
        |> redirect(to: project_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => project_id}) do
    Repo.get!(Project, project_id)
    |> Repo.delete!()

    conn
    |> put_flash(:info, "Проект успешно удален.")
    |> redirect(to: project_path(conn, :index))
  end
end
