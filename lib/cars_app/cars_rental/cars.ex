defmodule CarsApp.CarsRental.Cars do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cars" do
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
  end
end
