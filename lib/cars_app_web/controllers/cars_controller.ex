defmodule CarsAppWeb.CarsController do
  use CarsAppWeb, :controller

  alias CarsApp.CarsRental
  alias CarsApp.CarsRental.Cars
  alias CarsApp.CarsRentalSubscriptions

  action_fallback CarsAppWeb.FallbackController

  @doc """
  Retrieves all the cars paginated by default.
  It supports for filters :maker and/or :color

  ## Query params

    - maker: String
    - color: String
    - operand: String, default: AND

  ## Examples

      get /api/cars?maker=BMW&color=black&operand=or

  """
  def index(conn, query_params) do
    cars = CarsRental.list_cars(query_params, conn)
    render(conn, "index.json", car: cars)
  end

  @doc """
  Creates a car given the params

  ## Body params

    - maker: String, required
    - color: String
    - model: String
    - year: String
    - subscription: Object, example: %{price: 45.67, type: "monthly", currency: "eu"} 
                            ## All these fields are required if :subscription key is provided

  ## Examples

    post /api/cars
    body: {
      "car": {
        "maker": "bmw",
        "color": "blue",
        "model": "mondeo",
        "year": "2015",
        "subscription": {
            "currency": "lb",
            "price": 9.59,
            "type": "monthly"       
        }
      }
    }
  """
  def create(conn, %{"car" => attrs}) do
    with %Cars{} = car <-
           CarsRental.create_cars(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.cars_path(conn, :show, car))
      |> render("show.json", car: car)
    end
  end

  @doc """
  Retrieves a car by ID.

  ## Examples

      get /api/cars/2709d646-178c-41a0-9452-eae7acd9df98

  """
  def show(conn, %{"id" => id}) do
    cars = CarsRental.get_cars!(id)
    render(conn, "show.json", car: cars)
  end

  @doc """
  Updates a car

  ## Body params

    - maker: String, required
    - color: String
    - model: String
    - year: String

  ## Examples

    put /api/cars/2709d646-178c-41a0-9452-eae7acd9df98
    body: {
      "car": {
        "maker": "ford"
      }
    }
  """
  def update(conn, %{"id" => id, "car" => cars_params}) do
    cars = CarsRental.get_cars!(id)

    with %Cars{} = cars <- CarsRental.update_cars(cars, cars_params) do
      render(conn, "show.json", car: cars)
    end
  end

  @doc """
  Updates a subscription

  ## Examples

    put /api/subscription/2709d646-178c-41a0-9452-eae7acd9df98
    body: {
      "subscription": {
        "price": 35.47
      }
    }
  """
  def update_subscription(conn, %{"id" => id, "subscription" => params}) do
    subs = CarsRentalSubscriptions.get_subscription!(id)
    updated_subs = CarsRentalSubscriptions.update_subscription(subs, params)

    with %Cars{} = cars <- CarsRental.get_cars!(updated_subs.cars_id) do
      render(conn, "show.json", car: cars)
    end
  end

  @doc """
  Starts a subscription assocciated to the given car.
  The given ID corresponds to a car.

  ## Examples

    put /api/cars/start_subscription/2709d646-178c-41a0-9452-eae7acd9df98
    body: {
      "car": {
        "started_at": "2020-09-01"
      }
    }
  """
  def start_subscription(conn, %{"id" => id, "started_at" => started_at}) do
    car = CarsRental.get_cars!(id)
    {:ok, parsed_date} = Timex.parse(started_at <> " 00:00:00Z", "{ISO:Extended}")

    with %Cars{} = cars <- CarsRental.start_subscription(car, parsed_date) do
      render(conn, "show.json", car: cars)
    end
  end

  @doc """
  Deletes the given car
  
  ## Examples

    delete /api/cars/2709d646-178c-41a0-9452-eae7acd9df98
  """
  def delete(conn, %{"id" => id}) do
    cars = CarsRental.get_cars!(id)

    with {:ok, %Cars{}} <- CarsRental.delete_cars(cars) do
      send_resp(conn, :no_content, "")
    end
  end
end
