defmodule Scrumex.Router do
  use Scrumex.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Scrumex do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :home

    get "/signup", UserController, :new

    resources "/user", UserController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Scrumex do
  #   pipe_through :api
  # end
end
