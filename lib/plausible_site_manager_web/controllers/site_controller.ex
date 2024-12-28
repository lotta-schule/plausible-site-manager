defmodule PlausibleSiteManagerWeb.SiteController do
  use PlausibleSiteManagerWeb, :controller

  alias PlausibleSiteManager.Sites

  action_fallback PlausibleSiteManagerWeb.FallbackController

  def create(%{assigns: %{user: user}} = conn, %{"domain" => domain, "timezone" => timezone}) do
    with {:ok, site} <- Sites.create(user, domain, timezone) do
      conn
      |> put_status(:created)
      |> json(site)
    end
  end

  def delete(conn, %{"domain" => domain}) do
    with :ok <- Sites.delete(domain) do
      send_resp(conn, :no_content, "")
    end
  end
end
