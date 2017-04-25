defmodule Scrumex.PageController do
  use Scrumex.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
