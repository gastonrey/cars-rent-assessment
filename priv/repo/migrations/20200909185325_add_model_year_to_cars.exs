defmodule CarsApp.Repo.Migrations.AddModelYearToCars do
  use Ecto.Migration

  def change do
    alter table(:cars) do
      add :model, :string
      add :year, :string
    end
  end
end
