defmodule RentMe.Users.User do
    alias RentMe.Couch.Base, as: Base
    alias RentMe.Couch.Db, as: Db

    ##should we have an ets table that holds key, and email??
    ##api key should go in the header probably
    @enforce_keys [:email, :password_hash, :name, :location, :picture, :bio, :rating, :created, :api_key]
    defstruct [:email, :password_hash, :name, :location, :picture, :bio, :rating, :created, :api_key]

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
            created: DateTime.to_string(DateTime.utc_now()),
            api_key: :base64.encode(:crypto.strong_rand_bytes(24))
        }
        |>store_user
    end

    defp store_user(user = %__MODULE__{}) do
        with {:ok, _msg} <- Db.write_document(Base.rent_me_users_db(), user.email, Poison.encode!(user)),
             {:ok, _msg} <- Db.write_document(Base.rent_me_users_db(), user.api_key, Poison.encode!(%{"email"=>user.email})) do
                Base.add_user(user.email)
                {:ok, user}
        else
            {:error, msg} -> {:error, msg}
        end
    end

    def login(email, password) do
        with {:ok, user} <- Db.get_document(Base.rent_me_users_db(), email, "failed to find user"),
             true <- password_match(password, user["password_hash"]) do
                 {:ok, user |> to_struct()}
             else 
                 {:error, msg} -> {:error, msg}
                 _ -> {:error, "failed to validate user"}
             end
    end

    def validate(email, api_key) do
        with {:ok, user} <- Db.get_document(Base.rent_me_users_db(), api_key, "failed to find user"),
             true <- email == user["email"] do
                 {:ok, "valid user"}
             else 
                 {:error, msg} -> {:error, msg}
                 _ -> 
                     {:error, "invalid api key"}
             end
    end

    def hash(password) do
        Comeonin.Pbkdf2.hashpwsalt(password)
    end

    def password_match(password, hash) do
        Comeonin.Pbkdf2.checkpw(password, hash)
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