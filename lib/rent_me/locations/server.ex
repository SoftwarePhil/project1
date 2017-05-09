defmodule RentMe.Locations.Server do
    use GenServer
    alias RentMe.Couch.Db, as: Db
    #new location? make new database
    #locations have users and items

    #log when a city was created in RentMe db
    # 
    def start_link(location) do
        case init_db(location) do
            {:ok, db_config} -> GenServer.start_link(__MODULE__, [location, db_config], name: {:global, location})
            {:error, msg} -> {:error, "failed to create database"}
        end 
    end

    def handle_call(:state, _from, state) do
        {:reply, state, state}
    end

    def state(location) do
        GenServer.call({:global, location}, :state)
    end

    def init_db(location) do
        db.init(location)
    end
end