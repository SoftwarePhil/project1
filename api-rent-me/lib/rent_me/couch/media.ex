defmodule RentMe.Couch.Media do
    alias RentMe.Couch.Db, as: Db
    
    defp save_media(db, type, item) do
        id = type<>rand()
        Db.write_document(db, id, %{type=>item}, :map)
        id
    end

    defp rand do
        15 |> :crypto.strong_rand_bytes() |> :base64.encode()
    end

     @doc"""
        this function saves some item to a database with a unique key
        It takes the db, type of thing being saved(can be arbitrary), the actual item, and the parent document
        
        This is useful for saving larger items such as pictures as we do not want
        to load a whole picture in to memory if we only need other attrubies of the parent document
    """
    def save_attachment(db, type, item, doc) do
         cond do 
            doc[type]==type -> 
                id = save_media(db, type, item)
                Db.update_document(db, doc, type, id, "picture saved")
                id
            true -> 
                id = doc[type]
                {:ok, old} = Db.get_document(db, id, "failed to get #{type} with id #{id} from database")
                Db.update_document(db, old, type, item, "updated #{id} document")
                id
        end
    end
        #cond do 
            #doc[type]==type -> make new attachment
            #true -> update old attachment
       
        #id <- Media.save_media(Base.rent_me_users_db(), "picture", pic),
        #{:ok, _doc} <- Db.update_document(Base.rent_me_users_db(), user, "picture", id, "picture saved")
end