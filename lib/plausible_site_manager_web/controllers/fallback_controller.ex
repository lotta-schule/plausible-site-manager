defmodule PlausibleSiteManagerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PlausibleSiteManagerWeb, :controller

  require Logger

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(PlausibleSiteManagerWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, message}) do
    Logger.error("Internal server error: #{inspect(message)}")

    conn
    |> put_status(:internal_server_error)
    |> put_view(PlausibleSiteManagerWeb.ErrorView)
    |> render(:"500")
  end
end
