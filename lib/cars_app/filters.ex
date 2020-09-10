defmodule CarsApp.Filters do
  defmacro __using__(_opts) do
    quote do
      use Inquisitor

      def build_query(query, "maker", maker, %{"operand" => operand}) do
        case operand do
          "or" -> Ecto.Query.or_where(query, [p], p.maker == ^maker)
          _ -> Ecto.Query.where(query, [p], p.maker == ^maker)
        end
      end

      def build_query(query, "color", color,%Plug.Conn{query_params: %{"operand" => operand}}) do
        case operand do
          "or" -> Ecto.Query.or_where(query, [p], p.color == ^color)
          _ -> Ecto.Query.where(query, [p], p.color == ^color)
        end
      end
    end
  end
end
