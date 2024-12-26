defmodule PlausibleSiteManager.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do

      timestamps(type: :utc_datetime)
    end
  end
end
