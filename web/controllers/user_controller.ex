defmodule Scrumex.UserController do
  use Scrumex.Web, :controller

  alias Scrumex.User

  def new(conn, params) do
    user = %User{
      first_name: Map.get(params, "first_name"),
      last_name: Map.get(params, "last_name"),
      email: Map.get(params, "email"),
      password: Map.get(params, "password")}

    render(conn, "new.html", changeset: User.changeset(user), user: nil)
  end

  def create(conn, %{"user" => user_params = %{"email" => email}}) do
    if user = Repo.one(from u in User, where: u.email == ^email) do
      welcome(conn, user)
    else
      changeset = User.changeset(%User{}, user_params)

      case Repo.insert(changeset) do
        {:ok, user} ->
          welcome(conn, user)
        {:error, changeset} ->
          conn
          |> put_flash(:error, "Что-то пошло не так. 😭")
          |> render(:new, changeset: changeset, user: nil)
      end
    end
  end

  defp welcome(conn, user) do
    conn
    |> put_flash(:success, "Добро пожаловать в Scrumex!")
    |> render(:new, user: user)
  end
end
