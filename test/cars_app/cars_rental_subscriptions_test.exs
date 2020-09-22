defmodule CarsApp.CarsRentalSubscriptionsTest do
  use CarsApp.DataCase

  alias CarsApp.CarsRentalSubscriptions
  alias CarsApp.CarsRentalSubscriptions.Subscription

  defp clean_up(_) do
    Repo.delete_all(Subscription)

    :ok
  end

  setup_all do
    on_exit(fn ->
      clean_up([])
    end)

    :ok
  end

  describe "subscription" do
    alias CarsApp.CarsRentalSubscriptions.Subscription

    @valid_attrs %{currency: "eu", price: 120.5, type: "monthly"}
    @update_attrs %{currency: "lb", price: 456.7}
    @invalid_attrs %{currency: "foo", type: "bar"}

    def subscription_fixture(attrs \\ %{}) do
      attrs
      |> Enum.into(@valid_attrs)
      |> CarsRentalSubscriptions.create_subscription()
    end

    test "list_subscription/0 returns all subscription" do
      subscription_fixture()
      assert length(CarsRentalSubscriptions.list_subscription()) > 0
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert CarsRentalSubscriptions.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      assert subscription = CarsRentalSubscriptions.create_subscription(@valid_attrs)
      assert subscription.currency == "eu"
      assert subscription.price == 120.5
      assert subscription.type == "monthly"
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CarsRentalSubscriptions.create_subscription(@invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      subscription = CarsRentalSubscriptions.update_subscription(subscription, @update_attrs)
      assert subscription.currency == "lb"
      assert subscription.price == 456.7
      assert subscription.type == "monthly"
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()
      assert_raise Ecto.InvalidChangesetError, fn ->
        CarsRentalSubscriptions.update_subscription(subscription, @invalid_attrs)
      end
      assert subscription == CarsRentalSubscriptions.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = CarsRentalSubscriptions.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> CarsRentalSubscriptions.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = CarsRentalSubscriptions.change_subscription(subscription)
    end
  end
end
