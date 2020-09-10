defmodule CarsApp.CarsRental do
  @moduledoc """
  The CarsRental context.
  """

  import Ecto.Query, warn: false
  use CarsApp.Filters

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
  def list_cars(query_params \\ %{}, conn) do
    three_months_ahead_from_now = Timex.now() |> Timex.shift(months: +3)
    Cars
    |> build_query(conn, query_params)
    |> join(:left, [c], s in assoc(c, :subscription))
    |> where([c, s], c.available_from <= ^three_months_ahead_from_now)
    |> order_by([c, s], [{:asc, s.price}])
    |> preload([c, s], subscription: s)
    |> Repo.all()
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
  def get_cars!(id), do: Repo.get!(Cars, id) |> Repo.preload([:subscription])

  @doc """
  Creates a cars with assocciated subscription

  ## Examples

      iex> create_cars(%{field: value})
      {:ok, %Cars{}}

      iex> create_cars(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cars(attrs \\ %{}) do
    car =
      %Cars{}
      |> Repo.preload([:subscription])
      |> Cars.changeset(attrs)
      |> Repo.insert!()
      |> add_subscription(attrs)
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
    cars
    |> Repo.preload([:subscription])
    |> Cars.changeset(attrs)
    |> Repo.update!()
  rescue
    e in Ecto.InvalidChangesetError -> {:error, e.changeset}
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

  def start_subscription(car, started_at) do
    [subscription] = car.subscription

    result =
      subscription
      |> CarsRentalSubscriptions.update_subscription(%{
        started_at: DateTime.truncate(started_at, :second)
      })

    update_availability(car)
  end

  def add_subscription(car, params)
      when is_map_key(params, "subscription") or is_map_key(params, :subscription) do
    params = params |> key_to_atom()

    car = car |> Repo.preload([:subscription])

    result =
      car
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:subscription, [
        struct(%Subscription{}, params[:subscription] |> key_to_atom()) | car.subscription
      ])
      |> Repo.update!()

    update_availability(result)
  end

  def add_subscription(car, _) do
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
    |> Repo.preload([:subscription])
    |> Ecto.Changeset.change(%{available_from: available_next_month})
    |> Repo.update!()
  end

  defp update_availability(%Cars{} = car) do
    update_cars(car, %{available_from: Timex.now()})
  end

  def key_to_atom(%{} = map) do
    Enum.reduce(map, %{}, fn
      {key, value}, acc when is_atom(key) -> Map.put(acc, key, value)
      # String.to_existing_atom saves us from overloading the VM by
      # creating too many atoms. It'll always succeed because all the fields
      # in the database already exist as atoms at runtime.
      {key, value}, acc when is_binary(key) -> Map.put(acc, String.to_existing_atom(key), value)
    end)
  end
end
