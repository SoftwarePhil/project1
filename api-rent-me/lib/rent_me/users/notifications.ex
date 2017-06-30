defmodule RentMe.Users.Notifcation do
    use GenServer
    #should we have a notification db?? store in users??
    alias RentMe.Couch.Base, as: Base
    alias RentMe.Couch.Util, as: Util

    #{:rental_time, :expired, :serious}
    #{event, state, urgency}

    def start_link do
        GenServer.start_link(__MODULE__, load_users(), name: __MODULE__)
    end

    def load_users do
        Base.all_users
        |>Enum.reduce(%{}, fn(user, acc) -> Map.put(acc, user, []) end)
    end

    #not safe
    def handle_cast({:notify, event, email}, state) do
        {:noreply, %{state | email => Util.add_to_list(state[email], event)}}    
    end

    def handle_call(:state, _from, state) do
        {:reply, state, state}     
    end
    
    def notify_user(email, event) do
       IO.puts("need to alert user "<>email)
       GenServer.cast(__MODULE__, {:notify, event, email})
    end

    def state do
        GenServer.call(__MODULE__, :state)
    end

end