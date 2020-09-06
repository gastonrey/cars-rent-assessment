defmodule CarsApp.Test.Support.Factory do
  alias CarsApp.Repo
  alias CarsApp.CarsRental.Cars
  alias CarsApp.CarsRentalModels.Models
  alias CarsApp.CarsRental

  def build(:car) do
    %Cars{maker: "BMW", color: "Red"}
  end

  def build(:model) do
    %Models{name: "Serie foo", year: "2019"}
  end

  def build(:car_with_model) do
    car = insert!(:car)
    model = insert!(:model)

    Cars.add_model(car, model)
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert!(build(factory_name, attributes))
  end
end
