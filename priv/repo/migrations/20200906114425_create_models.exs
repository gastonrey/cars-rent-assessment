defmodule CarsApp.Repo.Migrations.CreateModels do
  use Ecto.Migration

  def change do
    create table(:models, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :year, :string

      timestamps()
    end

  end
end
