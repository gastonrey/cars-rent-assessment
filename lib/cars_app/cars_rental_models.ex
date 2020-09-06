defmodule CarsApp.CarsRentalModels do
  @moduledoc """
  The CarsRentalModels context.
  """

  import Ecto.Query, warn: false
  alias CarsApp.Repo

  alias CarsApp.CarsRentalModels.Models

  @doc """
  Returns the list of models.

  ## Examples

      iex> list_models()
      [%Models{}, ...]

  """
  def list_models do
    Repo.all(Models)
    |> Repo.preload(:cars)
  end

  @doc """
  Gets a single models.

  Raises `Ecto.NoResultsError` if the Models does not exist.

  ## Examples

      iex> get_models!(123)
      %Models{}

      iex> get_models!(456)
      ** (Ecto.NoResultsError)

  """
  def get_models!(id), do: Repo.get!(Models, id) |> Repo.preload(:cars)

  @doc """
  Creates a models.

  ## Examples

      iex> create_models(%{field: value})
      {:ok, %Models{}}

      iex> create_models(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_models(attrs \\ %{}) do
    %Models{}
    |> Repo.preload(:cars)
    |> Models.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a models.

  ## Examples

      iex> update_models(models, %{field: new_value})
      {:ok, %Models{}}

      iex> update_models(models, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_models(%Models{} = models, attrs) do
    models
    |> Repo.preload(:cars)
    |> Models.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a models.

  ## Examples

      iex> delete_models(models)
      {:ok, %Models{}}

      iex> delete_models(models)
      {:error, %Ecto.Changeset{}}

  """
  def delete_models(%Models{} = models) do
    Repo.delete(models)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking models changes.

  ## Examples

      iex> change_models(models)
      %Ecto.Changeset{data: %Models{}}

  """
  def change_models(%Models{} = models, attrs \\ %{}) do
    Models.changeset(models, attrs)
  end
end
