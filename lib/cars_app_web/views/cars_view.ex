defmodule CarsAppWeb.CarsView do
  use CarsAppWeb, :view
  alias CarsAppWeb.CarsView
  alias CarsApp.CarsRentalModels.Models

  def render("index.json", %{car: cars}) do
    %{data: render_many(cars, CarsView, "cars.json")}
  end

  def render("show.json", %{car: car}) do
    %{data: render_one(car, CarsView, "cars.json")}
  end

  def render("cars.json", %{cars: car}) do
    %{id: car.id,
      maker: car.maker,
      color: car.color,
      available_from: car.available_from,
      model: nil,
      subscription: get_subscription_from(car.subscription)}
  end

  defp get_model(model) do
    case model do
      %Models{} -> 
        model
        |> Map.from_struct()
        |> Map.take([:name, :year])
      nil -> nil
    end
  end

  defp get_subscription_from(subs) do
    case subs do
      [_ | _] ->
        Enum.map(subs, fn a ->
          a
          |> Map.from_struct()
          |> Map.take([:currency, :price, :started_at, :type, :id])
        end)
      [] -> []
    end
  end
end
