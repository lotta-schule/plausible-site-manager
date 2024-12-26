defmodule PlausibleSiteManager.Sites do
  @moduledoc """
  The Sites context.
  """

  alias PlausibleSiteManager.DB

  def create(user, domain, timezone) do
    site =
      DB.map!(
        """
          INSERT INTO sites (
            domain, timezone, inserted_at, updated_at
          ) VALUES (
            $1, $2, now(), now()
          )
          RETURNING *
        """,
        [domain, timezone]
      )

    DB.query!(
      """
      INSERT INTO site_memberships (
        user_id, site_id, inserted_at, updated_at
      ) VALUES (
        $1, $2, now(), now()
      )
      """,
      [user["id"], site["id"]]
    )

    {:ok, site}
  end

  def delete(domain) do
    DB.affected!(
      "DELETE FROM sites WHERE domain = $1",
      [domain]
    )
    |> case do
      0 -> {:error, "site not found"}
      _ -> :ok
    end
  end
end
