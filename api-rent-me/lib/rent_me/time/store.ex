defmodule RentMe.Time.Store do
    alias RentMe.Time.Rental, as: Rental
    alias RentMe.Couch.Db, as: Db
    alias RentMe.Time.Server, as: Server

    #these things needs their own supervisors 
        #also should limit interaction with loction server as much as possible, should this be completely independent??

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
        |>Enum.each(fn(rental) -> add_item(id, Rental.to_struct(rental), :ets) end)
        id
    end

    
    def add_item(ets, rental_struct = %Rental{event: event}, :ets) do
        #what if item exists in ets it will get overwritten? what if key exists in couchdb? should write happen here?
        rental = {event.id, rental_struct}
        case :ets.insert(ets, rental) do
            true ->
                Server.add_rental(rental.item.city, rental) 
                {:ok, rental}
            _ -> {:error, "failed to add item"}
        end
    end
    def add_item(ets, rental_struct = %Rental{event: event}, database) do
        #what if item exists in ets it will get overwritten? what if key exists in couchdb? should write happen here?
        rental = {event.id, rental_struct}
        case :ets.insert(ets, rental) do
            true ->
                Server.add_rental(rental.item.city, rental) 
                Task.start(Db, :write_document, [database, event.id, rental_struct |> Poison.encode!()])
                Task.start(Db, :append_to_document, [database, "rentals", "list", event.id, "failed to presist item in database"])
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