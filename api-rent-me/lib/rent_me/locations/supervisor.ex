defmodule RentMe.Locations.Supervisor do
    use Supervisor
    import Supervisor.Spec
    alias RentMe.Locations.Server, as: Server
    alias RentMe.Couch.Base, as:  Base

    #TODO:: save ets tables in another ets so on restart we don't remake tables??
    
    def start_link do 
        Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init([]) do
        :ets.new(:info, [:named_table, :public])
        children = [
            worker(Server, [], restart: :permanent)
        ]

        supervise(children, strategy: :simple_one_for_one)
    end

    def add_location({:reload, city}) do
        res = Supervisor.start_child(__MODULE__, [:reload, city])
        save_table_ids(city)
        res
    end

    def add_location(city) do
        res = Supervisor.start_child(__MODULE__, [city])
        save_table_ids(city)
        res
    end

    def reload_all_locations do
        Base.all_locations()
        |>Enum.map(fn({city, _db_config}) -> 
            db_config = Base.get_location_db(city)
            res = Supervisor.start_child(__MODULE__, [:reload, {city, db_config}]) 
            save_table_ids(city)
            res
        end)
    end

    def save_table_ids(city) do
        %{items: i, rentals: r} = Server.state(city)
        :ets.insert(:info, {city, i, r})
    end

    def get_ets_table_ids(city) do
        case :ets.lookup(:info, city) do
            [] -> {:error, "city never created"}
            [{_city, items, rentals}] -> {:ok, {items, rentals}}
        end
    end
end