defmodule RentMe.Time.Supervisor do
    use Supervisor
    import Supervisor.Spec
    alias RentMe.Time.Server, as: Server

    #alias RentMe.Couch.Base, as:  Base

    #TODO:: save ets tables in another ets so on restart we don't remake tables??
    
    def start_link do 
        Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init([]) do
        children = [
            worker(Server, [], restart: :permanent)
        ]

        supervise(children, strategy: :simple_one_for_one)
    end

    def add_location(city) do
        Supervisor.start_child(__MODULE__, [city])
    end
end