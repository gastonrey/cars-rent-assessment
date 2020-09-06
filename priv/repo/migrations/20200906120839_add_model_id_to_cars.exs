defmodule CarsApp.Repo.Migrations.AddModelIdToCars do
  use Ecto.Migration

  def change do
    alter table(:cars) do
      add :models_id, references(:models, type: :binary_id, on_delete: :delete_all)
    end
  end
end
