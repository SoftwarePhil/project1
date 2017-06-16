defmodule RentMe.Items.Store do
    alias RentMe.Items.Item, as: Item
    alias RentMe.Couch.Db, as: Db

    def create_ets(location) do
        id = :ets.new(:location, [:set, :public])
        :ets.insert(id, {:location, location})
        id
    end

    def remake_ets(location, database) do
        id = :ets.new(:location, [:set, :public])
        :ets.insert(id, {:location, location})
  
        reload_items(database)
        |>Enum.each(fn(item) -> add_item({id, location}, Item.to_struct(item)) end)
        id
    end

    #item has city now, remove city from params ..
    def add_item({ets, city}, item_struct = %Item{user: user, name: name}) do
        #what if item exists in ets it will get overwritten? what if key exists in couchdb? should write happen here?
        item = {Item.id(city, user, name), name, item_struct.active, item_struct.tags, item_struct.description, item_struct.price}
        case :ets.insert(ets, item) do
            true -> 
                {:ok, item}
            _ -> {:error, "failed to add item"}
        end
    end

    def all_items(ets) do
        :ets.tab2list(ets)
    end

    def get_item(ets, id) do
        case :ets.lookup(ets, id) do
            [{_id, item}] -> {:ok, item}
            _ -> {:error, "item not found"}
        end
    end

    def reload_items(database) do
        {:ok, res} = Db.get_document(database, "items", "failed to get item list")

        res
        |>(fn(result) -> result["list"] end).()
        |>Enum.map(fn(item) -> 
                        {:ok, fetch} = Db.get_document(database, item, "item-not-found") 
                        fetch
                    end)
    end
end