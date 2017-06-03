defmodule RentMe.Locations.Supervisor do
    use Supervisor
    import Supervisor.Spec
    alias RentMe.Locations.Server, as: Server
    alias RentMe.Couch.Base, as: RentMeDb

    #TODO:: when a Locations.Server crashes restart it with :add_location [{:reload, city_name}
    
    def start_link do 
        Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init([]) do
        children = [
            worker(Server, [], restart: :transient)
        ]

        supervise(children, strategy: :simple_one_for_one)
    end

    def add_location({:reload, city}) do
        db_config = for {key, val} <- RentMeDb.get_location_db(city), into: %{}, do: {String.to_atom(key), val}
        
        Supervisor.start_child(__MODULE__, [:reload, {city, db_config}])
    end

    def add_location(city) do
        Supervisor.start_child(__MODULE__, [city])
    end

    def reload_all_locations do
        RentMeDb.all_locations()
        |>Enum.map(fn({city, db_config}) -> 
            db_config = for {key, val} <- db_config, into: %{}, do: {String.to_atom(key), val}
            Supervisor.start_child(__MODULE__, [:reload, {city, db_config}]) 
        end)
    end
end