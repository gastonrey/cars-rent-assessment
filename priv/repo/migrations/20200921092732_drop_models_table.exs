defmodule CarsApp.Repo.Migrations.DropModelsTable do
  use Ecto.Migration

  def change do
    alter table(:cars) do
      remove :models_id
    end
  end

  def down do
    execute "ALTER TABLE cars DROP CONSTRAINT IF EXISTS cars_models_id_fkey"
    flush()
    drop_if_exists table("models")
    flush()
  end
end
