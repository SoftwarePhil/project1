defmodule RentMe.Locations.Server do
    use GenServer
    #new location? make new database
    #locations have users and items

    #use process registry to hold names of cities?
    # 
    def start_link(location) do
        GenServer.start_link(__MODULE__, location, name: {:global, location})
    end

    def handle_call(:state, _from, state) do
        {:reply, state, state}
    end

    def state(location) do
        GenServer.call({:global, location}, :state)
    end
end