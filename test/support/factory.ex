defmodule CarsApp.Test.Support.Factory do
  alias CarsApp.Repo
  alias CarsApp.CarsRental.Cars
  alias CarsApp.CarsRentalModels.Models
  alias CarsApp.CarsRentalSubscriptions.Subscription
  alias CarsApp.CarsRental

  def build(:car) do
    %Cars{maker: "BMW", color: "Red"}
  end

  def build(:model) do
    %Models{name: "Serie foo", year: "2019"}
  end

  def build(:subs) do
    %Subscription{type: "monthly", price: 235.87, "currency": "eu"}
  end

  def build(:car_with_model) do
    car = insert!(:car)
    model = insert!(:model)

    CarsRental.add_model(car, model)
  end

  def build(:car_with_subscription) do
    car = insert!(:car)
    subs = insert!(:subs)

    CarsRental.add_subscription(car, Map.from_struct(subs))
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert!(build(factory_name, attributes))
  end
end
