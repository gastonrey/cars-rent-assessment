defmodule CarsApp.CarsRentalTest do
  use CarsApp.DataCase

  alias CarsApp.CarsRental.Cars
  alias CarsApp.CarsRentalSubscriptions.Subscription
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
    @valid_attrs %{maker: "bmw", color: "some color"}
    @valid_attrs_with_model %{year: "2018", name: "Yaris"}
    @update_attrs %{color: "some updated color"}
    @invalid_attrs %{maker: nil}
    @subscription_attrs %{type: "monthly", price: 19.20, currency: "eu"}

    def cars_fixture(attrs \\ %{}) do
      attrs
      |> Enum.into(@valid_attrs)
      |> CarsRental.create_cars()
    end

    test "list_cars/0 returns all cars" do
      cars_fixture()
      assert length(CarsRental.list_cars()) > 0
    end

    test "get_cars!/1 returns the cars with given id" do
      cars = cars_fixture()
      assert CarsRental.get_cars!(cars.id) == cars
    end

    test "create_cars/1 with valid data creates a cars" do
      car = CarsRental.create_cars(@valid_attrs)
      assert car.available_from != nil
      assert car.color == "some color"
    end

    test "create_cars with subscription" do
      car = CarsRental.create_cars(Map.merge(@valid_attrs, %{subscription: @subscription_attrs}))
      car_id = car.id
      assert [%Subscription{cars_id: car_id}] = car.subscription
    end

    test "create_cars with model" do
      car = CarsRental.create_cars(Map.merge(@valid_attrs, %{model: @valid_attrs_with_model}))
      assert car.models_id != nil
    end

    test "create_cars with all parameters" do
      additional_params = %{subscription: @subscription_attrs, model: @valid_attrs_with_model}
      car = CarsRental.create_cars(Map.merge(@valid_attrs, additional_params))
      car_id = car.id
      assert car.models_id != nil
      assert [%Subscription{cars_id: car_id}] = car.subscription
    end

    test "create_cars/1 with invalid data returns error changeset" do
      assert_raise Ecto.InvalidChangesetError, fn ->
        CarsRental.create_cars(@invalid_attrs)
      end
    end

    test "update_cars/2 with valid data updates the cars" do
      cars = cars_fixture()
      assert {:ok, %Cars{} = cars} = CarsRental.update_cars(cars, @update_attrs)
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

    test "start_subscription/2 subscription is started and car is available next month" do
      car = Factory.build(:car_with_subscription)
      changed_car = CarsRental.start_subscription(car, Timex.now())
      car_with_subscription = CarsRental.get_cars!(car.id)
      [%Subscription{started_at: started_at}] = car_with_subscription.subscription
      assert Timex.before?(car_with_subscription.available_from, started_at) == false
    end
  end
end
