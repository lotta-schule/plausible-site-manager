defmodule PlausibleSiteManagerWeb.Plug.Auth do
  import Plug.Conn

  alias PlausibleSiteManager.DB

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, token} <- get_bearer_token(conn),
         {:ok, user_id} <- IO.inspect(verify_token(token), label: "verify_token"),
         {:ok, user} <- IO.inspect(fetch_user(user_id), label: "fetch_user") do
      conn
      |> assign(:user, user)
    else
      _ ->
        conn
        |> send_resp(401, "Unauthorized")
    end
  end

  defp get_bearer_token(conn) do
    case IO.inspect(get_req_header(conn, "authorization")) do
      ["Bearer " <> token] -> {:ok, token}
      _ -> :error
    end
  end

  defp verify_token(token) do
    hash =
      :crypto.hash(:sha256, IO.inspect([secret_key_base(), token]))
      |> Base.encode16()
      |> String.downcase()

    IO.inspect(hash, label: "hash")

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
