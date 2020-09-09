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
      model: car.model,
      year: car.year,
      available_from: car.available_from,
      subscription: get_subscription_from(car.subscription)}
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
