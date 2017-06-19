defmodule RentMe.Time.Store do
    alias RentMe.Time.Rental, as: Rental
    alias RentMe.Couch.Db, as: Db

    #TODO: this can be made generic, it is almost the same as RentMe.Item.Store
    #find a common way to monitor all these ets tables?
    #might need one for payments??users??
    def create_ets(location) do
        id = :ets.new(:rental, [:set, :public])
        :ets.insert(id, {:rental, location})
        id
    end

    def remake_ets(location, database) do
        id = :ets.new(:rental, [:set, :public])
        :ets.insert(id, {:rental, location})
  
        reload_items(database)
        |>Enum.each(fn(rental) -> add_item(id, Rental.to_struct(rental)) end)
        id
    end

    def add_item(ets, rental_struct = %Rental{event: event}) do
        #what if item exists in ets it will get overwritten? what if key exists in couchdb? should write happen here?
        rental = {event.id, rental_struct}
        case :ets.insert(ets, rental) do
            true -> 
                {:ok, rental}
            _ -> {:error, "failed to add item"}
        end
    end

    def all_items(ets) do
        :ets.tab2list(ets)
    end

    def reload_items(database) do
        {:ok, res} = Db.get_document(database, "rentals", "failed to get item list")

        res
        |>(fn(result) -> result["list"] end).()
        |>Enum.map(fn(rental) -> 
                        {:ok, fetch} = Db.get_document(database, rental, "item-not-found") 
                        fetch
                    end)
    end
end