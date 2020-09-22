defmodule CarsApp.Filters do
  defmacro __using__(_opts) do
    quote do
      use Inquisitor

      def build_query(query, "maker", maker, conn) do
        case get_operand(conn) do
          "or" -> Ecto.Query.or_where(query, [p], p.maker == ^maker)
          _ -> Ecto.Query.where(query, [p], p.maker == ^maker)
        end
      end

      def build_query(query, "color", color, conn) do
        case get_operand(conn) do
          "or" -> Ecto.Query.or_where(query, [p], p.color == ^color)
          _ -> Ecto.Query.where(query, [p], p.color == ^color)
        end
      end

      defp get_operand(conn) do
        %Plug.Conn{query_params: params} = conn
        Map.get(params, "operand")
      end
    end
  end
end
