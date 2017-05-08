defmodule RentMe.Locations.Supervisor do
    use Supervisor
    import Supervisor.Spec
    alias RentMe.Locations.Server, as: Server

    def start_link do 
        Supervisor.start_link(__MODULE__, [], name: :location)
    end

    def init([]) do
        children = [
            worker(Server, [], restart: :transient)
        ]

        supervise(children, strategy: :simple_one_for_one)
    end

    def add_location(city) do
        Supervisor.start_child(:location, [city])
    end
end