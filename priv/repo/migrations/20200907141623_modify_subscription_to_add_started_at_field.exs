defmodule CarsApp.Repo.Migrations.ModifySubscriptionToAddStartedAtField do
  use Ecto.Migration

  def change do
    alter table(:subscription) do
      add :started_at, :utc_datetime
    end
  end
end
