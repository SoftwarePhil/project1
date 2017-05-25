defmodule RentMe.Items.Item do
    defstruct [:user, :name, :active, :created, :location, :price, :tags, :description, :picture]

    def new_item(name, user, location, price, tags, description, picture) do
         %__MODULE__{
                name: name, 
                user: user, 
                active: false, 
                location: location, 
                price: price, 
                tags: tags, 
                description: description, 
                picture: picture,
                created: DateTime.to_string(DateTime.utc_now())
            }
    end

      def to_struct(%{"name"=>name, "user"=>user, "location"=>location, 
                      "price" => price, "tags"=>tags, "description"=>description, 
                      "picture"=>picture, "created"=>created, "active"=>active}) do
         %__MODULE__{
                name: name, 
                user: user, 
                active: active, 
                location: location, 
                price: price, 
                tags: tags, 
                description: description, 
                picture: picture,
                created: created
            }
    end

    def id(city, user, name) do
        "#{city}:#{user}:#{name}"
    end
end