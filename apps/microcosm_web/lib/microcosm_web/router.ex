defmodule MicrocosmWeb.Router do
  use MicrocosmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MicrocosmWeb do
    # Use the default browser stack
    pipe_through :browser

    get "/live", LiveGameController, :game
    get "/start", GameController, :start
    get "/next", GameController, :next_step
    get "/", PageController, :index
  end
end
