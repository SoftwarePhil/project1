defmodule RentMe.Time.Server do
    use GenServer

    alias RentMe.Time.Rental, as: Rental
    alias RentMe.Time.Event, as: Event
    alias RentMe.Users.User, as: User

    @time 1000

    def start_link(city) do
        {:ok, pid} = GenServer.start_link(__MODULE__, [], name: server_name(city))
        Process.send_after(pid, :update, @time)
        {:ok, pid}
    end

    def handle_call({:add, rental}, _from, state) do
        {:reply, :ok, state ++ [rental]}
    end

    def handle_info(:update, state) do
        {:noreply, update_events(state)}
    end    

    def add_rental(city, rental = %Rental{}) do
        GenServer.call(server_name(city), {:add, rental})
    end

    def server_name(city) do
        {:global, "events_"<>city}
    end

    defp update_events(state) do
        Enum.each(state, fn(rental = %Rental{}) -> 
            case Event.time_passed(rental.event) do
                time when time > 0 -> 
                    IO.inspect({:send, rental.user, rental.item})
                    User.alert_user(rental.user)
                time -> IO.inspect({:time, time})
            end
        end)
        Process.send_after(self(), :update, @time)
        state
    end 
end