defmodule PlausibleSiteManager.SitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PlausibleSiteManager.Sites` context.
  """

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{

      })
      |> PlausibleSiteManager.Sites.create_site()

    site
  end
end
