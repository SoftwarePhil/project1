defmodule RentMe.Locations.Server do
    use GenServer
    alias RentMe.Couch.Db, as: Db
    alias RentMe.Couch.Base, as: Base
    alias RentMe.Items.Store, as: ItemStore
    alias RentMe.Items.Item, as: Item
    alias RentMe.Time.Rental, as: Rental
    alias RentMe.Time.Store, as: RentalStore
    #locations have users and items

    #adding an item 
    #task to write to db
    #save whole item in map?? best way to search these? all items in an :ets table so we can query 

    # on restart/crash don't try to remake database, load items into server and items into ets table OR load from ets table
    # 
    def start_link(city) do
        with {:ok, db_config} <- init_db(city),
             {:ok, _db_config} <- Base.add_location(city, db_config),
             item_ets when item_ets != false <- ItemStore.create_ets(city),
             rental_ets when rental_ets != false <- RentalStore.create_ets(city),
             {:ok, pid} <- GenServer.start_link(__MODULE__, %{name: city, database: db_config, items: item_ets, rentals: rental_ets}, name: server_name(city)) do 
                {:ok, pid}
        else    
                {:error, msg} -> 
                    IO.inspect(msg)
                    {:error, "failed to create database/start server"}
        end 
    end

    #what if ets table exists already, it should not be remade
    def start_link(:reload, {city, db_config}) do
        #what if ets table still exists (the ets table does not crash with this process)
        with item_ets when item_ets != false <- ItemStore.remake_ets(city, db_config),
             rental_ets when rental_ets != false <- RentalStore.remake_ets(city, db_config),
             {:ok, pid} <- GenServer.start_link(__MODULE__, %{name: city, database: db_config, items: item_ets, rentals: rental_ets}, name: server_name(city)) do 
                {:ok, pid}
        else    
                {:error, _msg} -> 
                    {:error, "failed to reload location server"}
        end 
    end
    def start_link(:reload, city), do: start_link(:reload, {city, Base.get_location_db(city)})

    def handle_call(:state, _from, state) do
        {:reply, state, state}
    end

    def handle_call({:new_item, item}, _from, state) do
        #get ets,
        #call add item?
        #failure?
        #write to db as task
        #reply with created item

        #the ets knows the city no need to pass it in again??
        {:ok, {id, item}} = ItemStore.add_item({state.items, state.name}, item)
        #should this happen here?
        #we also need to add the item to a list of items
        Task.start(Db, :write_document, [state.database, id, Poison.encode!(item)])
        Task.start(Db, :append_to_document, [state.database, "items", "list", id, "failed to presist item in database"])
        {:reply, {:ok, id}, state}
    end

    def handle_call({:new_rental, rental}, _from, state) do
        {:ok, {id, rental}} = RentalStore.add_item(state.rentals, rental)
   
        Task.start(Db, :write_document, [state.database, id, Poison.encode!(rental)])
        Task.start(Db, :append_to_document, [state.database, "rentals", "list", id, "failed to presist item in database"])
        {:reply, {:ok, id}, state}
    end

    def state(name) do
        GenServer.call(server_name(name), :state)
    end

    def add_item(city, name, user, location, price, tags, description, picture) do
        #valid item??
        #use ecto to validate
        item = Item.new_item(name, user, city, location, price, tags, description, picture)
        GenServer.call(server_name(city), {:new_item, item})
    end

    def add_rental(item=%Item{}, user, rental_length) do
        rental = Rental.new_rental(user, item, rental_length)
        GenServer.call(server_name(item.city), {:new_rental, rental})
    end

    defp init_db(location) do
        location
        |>create_id()
        |>Db.init_db()
        |>set_up_city_doc()
    end

    defp create_id(location) do
        location
        |>String.downcase
        |>String.replace(", ", "_")
        |>String.replace(" ", "$")
    end

    def id_to_name(db_config) do
        db_config
        |>String.split("_")
        |>List.first
        |>String.replace("$", " ")
    end

    defp set_up_city_doc({:error, msg}), do: {:error, msg}
    defp set_up_city_doc({:ok, db}) do
        with {:ok, _msg} <- Db.write_document(db, "items", Poison.encode!(%{"list"=>[]})),
        {:ok, _msg} <- Db.write_document(db, "rentals", Poison.encode!(%{"list"=>[]})) do
            {:ok, db}
        else
            {:error, msg} -> {:error, msg}
        end
    end

    defp server_name(location) do
        {:global, location}
    end
end

# RentMe.Locations.Supervisor.add_location("Dallas, TX")
# RentMe.Locations.Server.add_item("Dallas, TX", "bike", "bob", "66,66", "5", "tags", "this is a good bike", "base64 encoded")