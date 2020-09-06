defmodule CarsApp.CarsRentalModels.Models do
  use Ecto.Schema
  import Ecto.Changeset
  alias CarsApp.CarsRental.Cars
  alias CarsApp.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "models" do
    field :name, :string
    field :year, :string
    has_many(:cars, CarsApp.CarsRental.Cars, [{:on_delete, :delete_all}, {:on_replace, :nilify}])

    timestamps()
  end

  @doc false
  def changeset(models, attrs) do
    models
    |> cast(attrs, [:name, :year])
    |> validate_required([:name, :year])
  end
end
