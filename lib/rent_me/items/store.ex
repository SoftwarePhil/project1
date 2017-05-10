defmodule RentMe.Items.Store do
    alias RentMe.Items.Item, as: Item

    def create_ets(location) do
        id = :ets.new(:location, [:set, :public])
        :ets.insert(id, {:location, location})
        id
    end

    def add_item({ets, city}, item_struct = %Item{user: user, name: name}) do

        #what if item exists in ets it will get overwritten? what if key exists in couchdb? should write happen here?
        item = {Item.id(city, user, name), item_struct}
        case :ets.insert(ets, item) do
            true -> 
                {:ok, item}
            _ -> {:error, "failed to add item"}
        end
    end

    def all_items(ets) do
        :ets.tab2list(ets)
    end
end