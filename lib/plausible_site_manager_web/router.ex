defmodule PlausibleSiteManagerWeb.Router do
  use PlausibleSiteManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

    plug PlausibleSiteManagerWeb.Plug.Auth
  end

  scope "/api/v1", PlausibleSiteManagerWeb do
    pipe_through :api

    get "/sites/:domain", SiteController, :get
    post "/sites", SiteController, :create
    delete "/sites/:domain", SiteController, :delete
  end
end
