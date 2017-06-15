defmodule Scrumex.ProjectController do
  use Scrumex.Web, :controller

  require Logger

  alias Scrumex.{Repo, User, Project, ProjectStatus, ProjectPriority}

  def index(conn, _params) do
    current_user = User.get_current(conn)

    owned_projects = current_user
    |> assoc(:owned_projects)
    |> Project.preload_all()
    |> Repo.all()

    render(conn, "index.html",
      owned_projects: owned_projects,
      layout: {Scrumex.LayoutView, "dark.html"})
  end

  def new(conn, _params) do
    project = %Project{}

    render(conn, "new.html", changeset: Project.changeset(project))
  end

  def create(conn, %{"project" => project_params}) do
    current_user = User.get_current(conn)

    changeset = current_user
    |> build_assoc(:owned_projects)
    |> Repo.preload(Project.preloaded)
    |> Project.changeset(project_params)

    Logger.warn "#{inspect(changeset)}"

    if changeset.valid? do
      Repo.transaction fn ->
        case Repo.insert(changeset) do
          {:ok, project} ->
            Enum.map(["Backlog", "In progress", "Done"], fn(x) ->
              project
              |> build_assoc(:statuses, name: x)
              |> ProjectStatus.changeset()
              |> Repo.insert!()
            end)

            Enum.map(["Critical", "Major", "Trivial"], fn(x) ->
              project
              |> build_assoc(:priorities, name: x)
              |> ProjectPriority.changeset()
              |> Repo.insert!()
            end)

            conn
            |> put_status(:created)
            |> put_flash(:success, "Проект успешно создан")
            |> redirect(to: project_path(conn, :index))
          {:error, changeset} ->
            conn
            |> put_flash(:error, "Что-то пошло не так. 😭 #{current_user.id}")
            |> render("new.html", changeset: changeset)
        end
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> put_flash(:error, "Валидация не прошла")
      |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => slug_id}) do
    project_id = Project.parse_slug_id(slug_id)
    |> elem(0)

    project = Project
    |> Project.preload_all()
    |> Repo.get(project_id)

    changeset = project
    |> build_assoc(:statuses)
    |> ProjectStatus.changeset()

    render(conn, "show.html",
      project: project,
      statuses: Project.statuses(project),
      changeset: changeset,
      layout: {Scrumex.LayoutView, "dark.html"})
  end

  def edit(conn, %{"id" => slug_id}) do
    project = Project.get_from_slug_id(slug_id)

    render(conn, "edit.html", changeset: Project.changeset(project), project: project)
  end

  def update(conn, %{"id" => slug_id, "project" => project_params}) do
    project = Project.get_from_slug_id(slug_id)
    changeset = Project.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, _project} ->
        conn
        |> put_flash(:info, "Проект успешно обновлен.")
        |> redirect(to: project_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => slug_id}) do
    Project.get_from_slug_id(slug_id)
    |> Repo.delete!()

    conn
    |> put_flash(:info, "Проект успешно удален.")
    |> redirect(to: project_path(conn, :index))
  end
end
