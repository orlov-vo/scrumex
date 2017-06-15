defmodule Scrumex.Project.TaskController do
  use Scrumex.Web, :controller

  alias Scrumex.{Project, Task, User}

  def index(conn, %{"project_id" => slug_id}) do
    project = Project.get_from_slug_id(slug_id)
    tasks = Repo.all(Task)
    render(conn, "index.html", project: project, tasks: tasks)
  end

  def new(conn, params = %{"project_id" => slug_id}) do
    project_id = Project.parse_slug_id(slug_id)
    |> elem(0)

    project = Project
    |> Project.preload_all()
    |> Repo.get(project_id)

    changeset = Task.changeset(%Task{})
    authors = Repo.all(User)

    render(conn, "new.html",
      project: project,
      changeset: changeset,
      status_id: params["status"],
      authors: authors
    )
  end

  def create(conn, %{"project_id" => slug_id, "task" => task_params}) do
    project = Project.get_from_slug_id(slug_id)
    changeset = Task.changeset(%Task{}, task_params)

    case Repo.insert(changeset) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: project_task_path(conn, :index, project))
      {:error, changeset} ->
        render(conn, "new.html", project: project, changeset: changeset)
    end
  end

  def show(conn, %{"project_id" => slug_id, "id" => id}) do
    project = Project.get_from_slug_id(slug_id)
    task = Repo.get!(Task, id)
    render(conn, "show.html", project: project, task: task)
  end

  def edit(conn, %{"project_id" => slug_id, "id" => id}) do
    project = Project.get_from_slug_id(slug_id)
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task)
    render(conn, "edit.html", project: project, task: task, changeset: changeset)
  end

  def update(conn, %{"project_id" => slug_id, "id" => id, "task" => task_params}) do
    project = Project.get_from_slug_id(slug_id)
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task, task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: project_task_path(conn, :show, project, task))
      {:error, changeset} ->
        render(conn, "edit.html", project: project, task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"project_id" => slug_id, "id" => id}) do
    project = Project.get_from_slug_id(slug_id)
    task = Repo.get!(Task, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: project_task_path(conn, :index, project))
  end
end
