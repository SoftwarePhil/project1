defmodule RentMe.Couch.Util do
    def check_keys(keys, map) do
        case Enum.map(keys, fn k -> Map.has_key?(map, k) end) |> Enum.all? do
            true -> {:ok, map}
            false -> {:error, "missing"}
        end
    end

    def equals(a, b) do
      case {a, b} do
           {a, b} when a == b -> true
            _ -> false
      end
    end
    
    def add_to_list(list, item) do
        case list do
            list when list == nil -> [item]
            _ ->
                list++[item]
                |>Enum.uniq()       
        end
    end
end