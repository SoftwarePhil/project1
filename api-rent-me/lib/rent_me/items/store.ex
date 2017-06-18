defmodule RentMe.Items.Store do
    alias RentMe.Items.Item, as: Item
    alias RentMe.Couch.Db, as: Db

    def create_ets(_location) do
        id = :ets.new(:location, [:set, :public])
        id
    end

    def remake_ets(location, database) do
        id = :ets.new(:location, [:set, :public])
  
        reload_items(database)
        |>Enum.each(fn(item) -> add_item({id, location}, Item.to_struct(item)) end)
        id
    end

    #item has city now, remove city from params ..
    def add_item({ets, city}, item_struct = %Item{user: user, name: name}) do
        #what if item exists in ets it will get overwritten? what if key exists in couchdb? should write happen here?
        item = {Item.id(city, user, name), name, user, item_struct.active, item_struct.tags, item_struct.description, item_struct.price, item_struct.location}
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
            [{id, name, user, active, tags, des, price, location}] -> {:ok, %{id: id, user: user,name: name, active: active, tags: tags, description: des, price: price, location: location}}
            _ -> {:error, "item not found"}
        end
    end
    #{id, name, user, item_struct.active, item_struct.tags, item_struct.description, item_struct.price, item_struct.location}
    #this is bad, should use :ets.select, docs explicitly say not to do this
    def search_items(ets, term) do
        :ets.tab2list(ets) |> Enum.filter(
            fn({_, item, _, _, _, _, _, _})-> 
               search_match?(term, item)
            end) 
            |> Enum.map(fn({id, name, _user, active, tags, des, price, _location}) -> 
                %{id: id, name: name, active: active, tags: tags, description: des, price: price}
            end)
    end
    def search_match?(term, name), do: String.downcase(name) |>String.match?(Regex.compile!("#{term}"))

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