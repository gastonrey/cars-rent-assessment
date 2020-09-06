defmodule CarsApp.CarsRentalModelsTest do
  use CarsApp.DataCase

  alias CarsApp.CarsRentalModels
  alias CarsApp.CarsRentalModels.Models
  alias CarsApp.Repo
  alias CarsApp.Test.Support.Factory

  defp clean_up(_) do
    Repo.delete_all(Models)

    :ok
  end

  setup_all do
    on_exit(fn ->
      clean_up([])
    end)

    :ok
  end

  describe "models" do
    alias CarsApp.CarsRentalModels.Models

    @valid_attrs %{name: "some name", year: "some year"}
    @update_attrs %{name: "some updated name", year: "some updated year"}
    @invalid_attrs %{name: nil, year: nil}

    def models_fixture(attrs \\ %{}) do
      {:ok, models} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CarsRentalModels.create_models()

      models
    end

    test "list_models/0 returns all models" do
      models_fixture()
      assert length(CarsRentalModels.list_models()) > 0
    end

    test "get_models!/1 returns the models with given id" do
      models = models_fixture()
      assert CarsRentalModels.get_models!(models.id) == models
    end

    test "create_models/1 with valid data creates a models" do
      assert {:ok, %Models{} = models} = CarsRentalModels.create_models(@valid_attrs)
      assert models.name == "some name"
      assert models.year == "some year"
    end

    test "create_models/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CarsRentalModels.create_models(@invalid_attrs)
    end

    test "update_models/2 with valid data updates the models" do
      models = models_fixture()
      assert {:ok, %Models{} = models} = CarsRentalModels.update_models(models, @update_attrs)
      assert models.name == "some updated name"
      assert models.year == "some updated year"
    end

    test "update_models/2 with invalid data returns error changeset" do
      models = models_fixture()
      assert {:error, %Ecto.Changeset{}} = CarsRentalModels.update_models(models, @invalid_attrs)
      assert models == CarsRentalModels.get_models!(models.id)
    end

    test "delete_models/1 deletes the models" do
      models = models_fixture()
      assert {:ok, %Models{}} = CarsRentalModels.delete_models(models)
      assert_raise Ecto.NoResultsError, fn -> CarsRentalModels.get_models!(models.id) end
    end

    test "change_models/1 returns a models changeset" do
      models = models_fixture()
      assert %Ecto.Changeset{} = CarsRentalModels.change_models(models)
    end
  end
end
