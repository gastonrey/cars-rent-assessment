defmodule CarsApp.CarsRentalTest do
  use CarsApp.DataCase

  alias CarsApp.CarsRental.Cars
  alias CarsApp.CarsRental
  alias CarsApp.Test.Support.Factory

  defp clean_up(_) do
    Repo.delete_all(Cars)

    :ok
  end

  setup_all do
    on_exit(fn ->
      clean_up([])
    end)

    :ok
  end

  describe "cars" do
    @valid_attrs %{maker: "bmw", available_from: "2010-04-17T14:00:00Z", color: "some color"}
    @update_attrs %{available_from: "2011-05-18T15:01:01Z", color: "some updated color"}
    @invalid_attrs %{maker: nil, available_from: nil, color: nil}

    def cars_fixture(attrs \\ %{}) do
      {:ok, cars} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CarsRental.create_cars()

      cars
    end

    test "list_cars/0 returns all cars" do
      cars = cars_fixture()
      assert length(CarsRental.list_cars()) > 0
    end

    test "get_cars!/1 returns the cars with given id" do
      cars = cars_fixture()
      assert CarsRental.get_cars!(cars.id) == cars
    end

    test "create_cars/1 with valid data creates a cars" do
      assert {:ok, %Cars{} = cars} = CarsRental.create_cars(@valid_attrs)
      assert cars.available_from == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert cars.color == "some color"
    end

    test "create_cars/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CarsRental.create_cars(@invalid_attrs)
    end

    test "update_cars/2 with valid data updates the cars" do
      cars = cars_fixture()
      assert {:ok, %Cars{} = cars} = CarsRental.update_cars(cars, @update_attrs)
      assert cars.available_from == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert cars.color == "some updated color"
    end

    test "update_cars/2 with invalid data returns error changeset" do
      cars = cars_fixture()
      assert {:error, %Ecto.Changeset{}} = CarsRental.update_cars(cars, @invalid_attrs)
      assert cars == CarsRental.get_cars!(cars.id)
    end

    test "delete_cars/1 deletes the cars" do
      cars = cars_fixture()
      assert {:ok, %Cars{}} = CarsRental.delete_cars(cars)
      assert_raise Ecto.NoResultsError, fn -> CarsRental.get_cars!(cars.id) end
    end

    test "change_cars/1 returns a cars changeset" do
      cars = cars_fixture()
      assert %Ecto.Changeset{} = CarsRental.change_cars(cars)
    end

    test "Created car has an assocciated model" do
      car = Factory.build(:car_with_model)
      assert car.models != nil
    end
  end
end
