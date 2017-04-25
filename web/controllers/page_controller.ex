defmodule Scrumex.PageController do
  use Scrumex.Web, :controller

  def home(conn, _params) do
    render conn, "home.html"
  end
end
