defmodule PlausibleSiteManagerWeb.Plug.Auth do
  import Plug.Conn

  alias PlausibleSiteManager.DB

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, token} <- get_bearer_token(conn),
         {:ok, user_id} <- verify_token(token),
         {:ok, user} <- fetch_user(user_id) do
      conn
      |> assign(:user, user)
    else
      _ ->
        conn
        |> send_resp(401, "Unauthorized")
    end
  end

  defp get_bearer_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      _ -> :error
    end
  end

  defp verify_token(token) do
    hash =
      :crypto.hash(:sha256, [secret_key_base(), token])
      |> Base.encode16()
      |> String.downcase()

    case DB.scalar!("SELECT user_id FROM api_keys WHERE key_hash = $1", [hash]) do
      nil -> :error
      user_id -> {:ok, user_id}
    end
  end

  defp secret_key_base do
    Application.get_env(:plausible_site_manager, PlausibleSiteManagerWeb.Endpoint)[
      :secret_key_base
    ]
  end

  defp fetch_user(user_id) do
    case DB.map!("SELECT * FROM users WHERE id = $1", [user_id]) do
      nil -> :error
      user -> {:ok, user}
    end
  end
end
