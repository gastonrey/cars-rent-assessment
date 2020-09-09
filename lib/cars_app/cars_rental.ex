defmodule CarsApp.CarsRental do
  @moduledoc """
  The CarsRental context.
  """

  import Ecto.Query, warn: false
  alias CarsApp.Repo

  alias CarsApp.CarsRental.Cars
  alias CarsApp.CarsRentalSubscriptions.Subscription
  alias CarsApp.CarsRentalSubscriptions

  @doc """
  Returns the list of cars.

  ## Examples

      iex> list_cars()
      [%Cars{}, ...]

  """
  def list_cars do
    Repo.all(Cars)
    |> Repo.preload(:models)
    |> Repo.preload(:subscription)
  end

  @doc """
  Gets a single cars.

  Raises `Ecto.NoResultsError` if the Cars does not exist.

  ## Examples

      iex> get_cars!(123)
      %Cars{}

      iex> get_cars!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cars!(id), do: Repo.get!(Cars, id) |> Repo.preload([:models, :subscription])

  @doc """
  Creates a cars.

  ## Examples

      iex> create_cars(%{field: value})
      {:ok, %Cars{}}

      iex> create_cars(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cars(
        attrs = %{
          "subscription" => %{
            "type" => type,
            "currency" => currency,
            "price" => price
          }
        }
      ) do
    create(attrs, %{type: type, currency: currency, price: price}, %{})
  end

  def create_cars(attrs = %{"model" => %{"name" => name, "year" => year}}) do
    create(attrs, %{}, %{name: name, year: year})
  end

  def create_cars(%{"maker" => maker, "color" => color} = attrs) do
    create(attrs, %{}, %{})
  end

  defp create(%{} = attrs, %{} = subscription, %{} = model) do
    car =
      %Cars{}
      |> Repo.preload([:models, :subscription])
      |> Cars.changeset(attrs)
      |> Repo.insert!()
      |> add_subscription(subscription)
      |> add_model(model)
  rescue
    e in Ecto.InvalidChangesetError -> {:error, e.changeset}
    e in [Postgrex.Error, MatchError] -> {:error, %{error: e.changeset.errors}}
  end

  @doc """
  Updates a cars.

  ## Examples

      iex> update_cars(cars, %{field: new_value})
      {:ok, %Cars{}}

      iex> update_cars(cars, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cars(%Cars{} = cars, attrs) do
    {:ok, car} =
      cars
      |> Repo.preload([:models, :subscription])
      |> Cars.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Deletes a cars.

  ## Examples

      iex> delete_cars(cars)
      {:ok, %Cars{}}

      iex> delete_cars(cars)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cars(%Cars{} = cars) do
    Repo.delete(cars)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cars changes.

  ## Examples

      iex> change_cars(cars)
      %Ecto.Changeset{data: %Cars{}}

  """
  def change_cars(%Cars{} = cars, attrs \\ %{}) do
    Cars.changeset(cars, attrs)
  end

  def add_model(car, attrs) do
    car = car |> Repo.preload(:models)

    car
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:models, attrs)
    |> Repo.update!()
  end

  def add_model(car, nil), do: car

  def start_subscription(car, started_at) do
    [subscription] = car.subscription

    result =
      subscription
      |> CarsRentalSubscriptions.update_subscription(%{
        started_at: DateTime.truncate(started_at, :second)
      })

    update_availability(car)
  end

  def add_subscription(car, %{} = attrs) do
    car = car |> Repo.preload([:models, :subscription])

    result =
      car
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:subscription, [
        struct(%Subscription{}, attrs) | car.subscription
      ])
      |> Repo.update!()

    update_availability(result)
  end

  def add_subscription(car, nil) do
    car = car |> Repo.preload([:subscription])
    update_availability(car)
  end

  defp update_availability(
         %Cars{subscription: [%Subscription{started_at: subscription_start}]} = car
       )
       when subscription_start != nil do
    available_next_month =
      subscription_start |> DateTime.from_naive!("Etc/UTC") |> Timex.shift(months: +1)

    car
    |> Repo.preload([:models, :subscription])
    |> Ecto.Changeset.change(%{available_from: available_next_month})
    |> Repo.update!()
  end

  defp update_availability(%Cars{} = car) do
    {:ok, result} = update_cars(car, %{available_from: Timex.now()})
    result
  end
end
