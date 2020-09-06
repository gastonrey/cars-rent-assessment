defmodule CarsApp.CarsRental.Cars do
  use Ecto.Schema
  import Ecto.Changeset
  alias CarsApp.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cars" do
    belongs_to :models, CarsApp.CarsRentalModels.Models
    field :maker, :string
    field :color, :string
    field :available_from, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(cars, attrs) do
    cars
    |> cast(attrs, [:maker, :color, :available_from])
    |> validate_required([:maker, :available_from])
    |> Repo.preload(:models)
  end

  def add_model(car, attrs) do
    car = car |> Repo.preload(:models)

    car
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:models, attrs)
    |> Repo.update!()
  end
end
