defmodule Scrumex.TaskControllerTest do
  use Scrumex.ConnCase

  alias Scrumex.Task
  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_task_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing tasks"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, project_task_path(conn, :new)
    assert html_response(conn, 200) =~ "New task"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, project_task_path(conn, :create), task: @valid_attrs
    assert redirected_to(conn) == project_task_path(conn, :index)
    assert Repo.get_by(Task, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_task_path(conn, :create), task: @invalid_attrs
    assert html_response(conn, 200) =~ "New task"
  end

  test "shows chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = get conn, project_task_path(conn, :show, task)
    assert html_response(conn, 200) =~ "Show task"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, project_task_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = get conn, project_task_path(conn, :edit, task)
    assert html_response(conn, 200) =~ "Edit task"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = put conn, project_task_path(conn, :update, task), task: @valid_attrs
    assert redirected_to(conn) == project_task_path(conn, :show, task)
    assert Repo.get_by(Task, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = put conn, project_task_path(conn, :update, task), task: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit task"
  end

  test "deletes chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = delete conn, project_task_path(conn, :delete, task)
    assert redirected_to(conn) == project_task_path(conn, :index)
    refute Repo.get(Task, task.id)
  end
end
