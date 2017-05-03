defmodule Scrumex.AuthController do
  use Scrumex.Web, :controller

  import Scrumex.Helper.CryptoCookie

  alias Scrumex.User

  plug Scrumex.Plug.RequireGuest, "before signing in" when action in [:new, :create]

  def new(conn, %{"auth" =>  %{"email" => email}}) do
    if user = Repo.one(from u in User, where: u.email == ^email) do
      user = user
      |> User.refresh_auth_token()
      |> Repo.update!()

      render(conn, "new.html", user: user)
    else
      conn
      |> put_flash(:success, "You aren't in our system! No worries, it's free to join. 💚")
      |> redirect(to: user_path(conn, :new, %{email: email}))
    end
  end

  def new(conn, _params) do
    render(conn, "new.html", user: nil)
  end

  def create(conn, %{"token" => token}) do
    [email, auth_token] = User.decoded_auth(token)
    user = Repo.get_by(User, email: email, auth_token: auth_token)

    if user && Timex.before?(Timex.now, user.auth_token_expires_at) do
      sign_in_and_redirect(conn, user, page_path(conn, :home))
    else
      conn
      |> put_flash(:error, "Воууу!")
      |> render("new.html", user: nil)
    end
  end

  def delete(conn, _params) do
    conn
      |> configure_session(drop: true)
      |> delete_resp_cookie("_scrumex_user")
      |> redirect(to: page_path(conn, :home))
  end

  defp sign_in_and_redirect(conn, user, route) do
    user
    |> User.sign_in_changeset()
    |> Repo.update!()

    conn
    |> configure_session(renew: true)
    |> assign(:current_user, user)
    |> put_flash(:success, "Добро пожаловать в Scrumex!")
    |> put_encrypted_cookie("_scrumex_user", user.id)
    |> redirect(to: route)
  end
end
