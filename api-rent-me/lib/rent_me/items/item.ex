defmodule RentMe.Items.Item do
    defstruct [:user, :name, :city, :active, :created, :location, :price, :tags, :description, :picture]

    def new_item(name, user, city, location, price, tags, description, picture) do
         %__MODULE__{
                name: name, 
                user: user, 
                city: city,
                active: false, 
                location: location, 
                price: price, 
                tags: tags, 
                description: description, 
                picture: picture,
                created: DateTime.to_string(DateTime.utc_now())
            }
    end

    def to_struct(%{"name"=>name, "user"=>user, "city"=>city, "location"=>location, 
                      "price" => price, "tags"=>tags, "description"=>description, 
                      "picture"=>picture, "created"=>created, "active"=>active}) do
        %__MODULE__{
            name: name, 
            user: user, 
            city: city, 
            active: active,
            location: location, 
            price: price, 
            tags: tags, 
            description: description, 
            picture: picture,
            created: created
        }
    end

    ##should id be derived like this??
    #might not be the best idea
    def id(city, user, name) do
        "#{city}:#{user}:#{name}"
    end
    
    def id(%__MODULE__{city: city, user: user, name: name}) do
        "#{city}:#{user}:#{name}"
    end
end