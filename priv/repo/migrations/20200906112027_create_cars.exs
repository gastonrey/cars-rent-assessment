defmodule CarsApp.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :maker, :string
      add :color, :string
      add :available_from, :utc_datetime

      timestamps()
    end

  end
end
