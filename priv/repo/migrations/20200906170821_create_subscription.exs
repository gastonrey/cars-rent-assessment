defmodule CarsApp.Repo.Migrations.CreateSubscription do
  use Ecto.Migration

  def change do
    create table(:subscription, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :price, :float
      add :currency, :string

      timestamps()
    end

  end
end
