defmodule RentMe.Couch.RentMe do
    alias RentMe.Couch.Db, as: Db
    alias RentMe.Couch.Util, as: Util

     @rent_me "store"
     @rent_me_users "users"
     
     @moduledoc """
        This module will act as the connection the the rentme_db which will hold
        the names of all locations and a refrence to the user_db.

        This acts as an important persistant data layer 
     """

    def init_rent_me do
        {:ok, db} = Db.init_db(@rent_me)
        {:ok, db_users} = Db.init_db(@rent_me_users)

        Db.write_document(db, "app", Poison.encode!(%{"locations"=>[], "user_db"=>db_users}))
        {:ok, db}
    end

    def rent_me do
        Db.db_config(@rent_me)
    end

    def add_location(location) do
        {:ok, doc} = Db.get_document(rent_me(), "app", "failed to fetch rent_me locations")
        locations = Util.add_to_list(doc["locations"], location)
        Db.update_document(rent_me(), doc, "locations", locations, "added location")
    end
end