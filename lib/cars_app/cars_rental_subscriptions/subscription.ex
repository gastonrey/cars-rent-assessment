defmodule CarsApp.CarsRentalSubscriptions.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_types ["monthly"]
  @supported_currencies ["eu", "usd", "lb"]
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "subscription" do
    belongs_to :cars, CarsApp.CarsRental.Cars
    field :currency, :string
    field :price, :float
    field :type, :string
    field :started_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:type, :price, :currency, :started_at])
    |> validate_inclusion(:type, @valid_types, message: "The given type is not allowed")
    |> validate_inclusion(:currency, @supported_currencies, message: "The given currency is not supported")
    |> validate_required([:type, :price, :currency])
  end
end
