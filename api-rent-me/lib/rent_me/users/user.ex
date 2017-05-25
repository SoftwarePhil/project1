defmodule RentMe.Users.User do
    alias RentMe.Couch.RentMe, as: RentMeDb
    alias RentMe.Couch.Db, as: Db

    @enforce_keys [:email, :password_hash, :name, :location, :picture, :bio, :rating]
    defstruct [:email, :password_hash, :name, :location, :picture, :bio, :rating]

    def user(email, password, name, location, picture, bio, rating) do
        %__MODULE__{
            email: email,
            password_hash: create_hash(password),
            name: name,
            location: location,
            picture: picture,
            bio: bio,
            rating: 0
        }
    end

    def store_user(user = %__MODULE__{}) do
        Db.write_document(RentMeDb.rent_me_user_db, user.email, Poison.encode!(user))
    end

    def create_hash(password) do
        password
    end
end