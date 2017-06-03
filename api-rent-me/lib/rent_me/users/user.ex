defmodule RentMe.Users.User do
    alias RentMe.Couch.Base, as: RentMeDb
    alias RentMe.Couch.Db, as: Db

    ##can the hash act as an api key??
    @enforce_keys [:email, :password_hash, :name, :location, :picture, :bio, :rating, :created]
    defstruct [:email, :password_hash, :name, :location, :picture, :bio, :rating, :created]

    #actual picture should be stored in seprate document
    def new_user(email, password, name, location) do
        %__MODULE__{
            email: email,
            password_hash: hash(password),
            name: name,
            location: location,
            picture: "picture",
            bio: "bio",
            rating: 0,
            created: DateTime.to_string(DateTime.utc_now())
        }
        |>store_user
    end


    defp store_user(user = %__MODULE__{}) do
        case Db.write_document(RentMeDb.rent_me_users_db(), user.email, Poison.encode!(user)) do
            {:ok, _msg} -> 
                RentMeDb.add_user(user.email)
                {:ok, user}
            {:error, msg} -> {:error, msg} 
        end
    end

    def login(email, password) do
        with {:ok, user} <- Db.get_document(RentMeDb.rent_me_users_db(), email, "failed to find user"),
             true <- password_match(password, user["password_hash"]) do
                 {:ok, user |> to_struct()}
             else 
                 {:error, msg} -> {:error, msg}
                 _ -> {:error, "failed to validate user"}
             end
    end

    def validate(email, api_key) do
        with {:ok, user} <- Db.get_document(RentMeDb.rent_me_users_db(), email, "failed to find user"),
             true <- api_key == user["password_hash"] do
                 {:ok, "valid user"}
             else 
                 {:error, msg} -> {:error, msg}
                 _ -> {:error, "invalid api key"}
             end
    end

    def hash(password) do
        password
    end

    def password_match(password, hash) do
        hash(password) == hash
    end

    def to_struct(attrs) do
        struct = struct(__MODULE__)
        Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
            case Map.fetch(attrs, Atom.to_string(k)) do
                {:ok, v} -> %{acc | k => v}
                :error -> acc
            end
        end
    end
end