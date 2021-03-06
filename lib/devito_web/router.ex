defmodule DevitoWeb.Router do
  use DevitoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug DevitoWeb.Plugs.APIAuth
  end

  scope "/api/", DevitoWeb do
    pipe_through :api
    get "/", API.LinkController, :index
    post "/link", API.LinkController, :create
    post "/import", API.LinkController, :import
    get "/:id", API.LinkController, :show
  end

  scope "/", DevitoWeb do
    pipe_through :browser
    get "/:short_code", LinkController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", DevitoWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DevitoWeb.Telemetry
    end
  end
end
