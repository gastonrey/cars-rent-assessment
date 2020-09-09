defmodule CarsApp.CarsRental.Cars do
  use Ecto.Schema
  import Ecto.Changeset
  alias CarsApp.Repo
  alias CarsApp.CarsRentalSubscriptions.Subscription

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cars" do
    has_many(:subscription, CarsApp.CarsRentalSubscriptions.Subscription, [
      {:on_delete, :delete_all},
      {:on_replace, :nilify}
    ])

    field :model, :string
    field :year, :string
    field :maker, :string
    field :color, :string
    field :available_from, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(cars, attrs) do
    cars
    |> cast(attrs, [:maker, :color, :available_from, :model, :year])
    |> validate_required([:maker])
  end
end
