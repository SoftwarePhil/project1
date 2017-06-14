defmodule RentMe.Time.Rental do
    alias RentMe.Time.Event, as: Event
    alias RentMe.Items.Item, as: Item

    defstruct [:user, :item, :event, :balance]
 
    def new_rental(user, item = %Item{}, rental_length) do
        event = create_id(user, Item.id(item))
        |>Event.new(rental_length)

        %__MODULE__{event: event, user: user, item: item, balance: 0}
    end

    def create_id(user, item) do
        user<>item<>":"<>:base64.encode(:crypto.strong_rand_bytes(10))
    end

    def to_struct(%{"user"=>user, "item"=>item, 
                     "event"=>event, "balance"=>balance}) do
        %__MODULE__{
            item: Item.to_struct(item), 
            user: user,
            event: Event.to_struct(event),
            balance: balance 
        }
    end

end