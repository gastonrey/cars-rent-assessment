defmodule CarsAppWeb.CarsController do
  use CarsAppWeb, :controller

  alias CarsApp.CarsRental
  alias CarsApp.CarsRental.Cars

  action_fallback CarsAppWeb.FallbackController

  def index(conn, _params) do
    cars = CarsRental.list_cars()
    render(conn, "index.json", car: cars)
  end

  def create(conn, %{"car" => attrs}) do
    with %Cars{} = car <-
           CarsRental.create_cars(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.cars_path(conn, :show, car))
      |> render("show.json", car: car)
    end
  end

  def show(conn, %{"id" => id}) do
    cars = CarsRental.get_cars!(id)
    render(conn, "show.json", car: cars)
  end

  def update(conn, %{"id" => id, "car" => cars_params}) do
    cars = CarsRental.get_cars!(id)

    with {:ok, %Cars{} = cars} <- CarsRental.update_cars(cars, cars_params) do
      render(conn, "show.json", car: cars)
    end
  end

  def delete(conn, %{"id" => id}) do
    cars = CarsRental.get_cars!(id)

    with {:ok, %Cars{}} <- CarsRental.delete_cars(cars) do
      send_resp(conn, :no_content, "")
    end
  end  
end
