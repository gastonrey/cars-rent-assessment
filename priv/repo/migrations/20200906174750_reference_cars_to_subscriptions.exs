defmodule CarsApp.Repo.Migrations.ReferenceCarsToSubscriptions do
  use Ecto.Migration

  def change do
    alter table(:subscription) do
      add :cars_id, references(:cars, type: :binary_id, on_delete: :delete_all)
    end
  end
end
